function init(){}

var getUrlParameter = function getUrlParameter(sParam){
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
    sURLVariables = sPageURL.split('&'),
    sParameterName,
    i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
}

const idTarea = getUrlParameter("ID");
const idUsuario = $('#user_idx').val();
const rolUsuario = $('#rol_idx').val();

function listardetalle(id_tarea){
    // Mostramos respuestas de la tarea
    $.post(
        "../../controller/tarea.php?op=listar_respuestas",
        {id_tarea : id_tarea},
        function(data){
            $('#pnlRespuestas').html(data);
        }
    )

    // Mostramos información de la Tarea en los input
    $.post(
        "../../controller/tarea.php?op=obtener",
        {id_tarea : id_tarea},
        function(data){
            data = JSON.parse(data)
            console.log(data)
            var elem_estado = '<span class="label label-pill label-success">Abierto</span>';

            // Devolver el estado de la tarea con formato
            if(data.estado_tarea == 1) {
                elem_estado = '<span class="label label-pill label-success">Abierto</span>'
            } else if(data.estado_tarea == 0) {
                elem_estado = '<span class="label label-pill label-danger">Finalizado</span>'
            } else {
                elem_estado = 'error'
            }

            if (data.estado_tarea == 0) {
                $('#lblRespuesta').hide();
            }

            $('#lblestado').html(elem_estado);
            $('#lblnomusuario').html(data.usu_nom + ' ' + data.usu_ape);
            $('#lblfechcrea').html(data.fecha_creacion);
            $('#lblnomidtarea').html("Detalle Tarea - "+data.id_tarea);
            $('#tarea_titulo').val(data.tarea_titulo);
            $('#id_ticket').val(data.id_ticket + ' ' + data.tick_titulo);
            $('#tarea_descripusu').summernote('code', data.tarea_desc);

        }
    )
}

$(document).ready(function(){
    var id_tarea = idTarea;
    const inputDocumentos = document.getElementById('fileElem');
    const textoError = document.getElementById('errorText');
    const btnEnviar = document.getElementById('btnEnviar');
    const tamanoMax = 3*1024*1024;

    // Restricción de tamaño de documentos
    inputDocumentos.addEventListener('change', function() {
        const documentos = inputDocumentos.files;
        let tamanoTotal = 0;

        for (let index = 0; index < documentos.length; index++) {
            tamanoTotal += documentos[index].size;
        }

        if (tamanoTotal > tamanoMax) {
            textoError.textContent = 'El tamaño de los documentos es mayor al límite';
            inputDocumentos.value = '';
            btnEnviar.style.display = 'none';
        } else {
            btnEnviar.style.display = 'block';
            textoError.textContent = '';
        }
    });
    
    listardetalle(id_tarea)

    if (rolUsuario == 3) {
        $('#btncerrartarea').hide();
    }

    $('#tarea_descripusu').summernote(
        {
            height: 400,
            lang: "es-ES",
            callbacks: {
                onImageUpload: function(image) {
                    console.log("Image detect...");
                    myimagetreat(image[0]);
                },
                onPaste: function (e) {
                    console.log("Text detect...");
                }
            },
            toolbar: [
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['font', ['strikethrough', 'superscript', 'subscript']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['height', ['height']]
            ]
        }
    )
    $('#tarea_descripusu').summernote('disable')

    $('#respTarea').summernote(
        {
            height: 400,
            lang: "es-ES",
            callbacks: {
                onImageUpload: function(image) {
                    console.log("Image detect...");
                    myimagetreat(image[0]);
                },
                onPaste: function (e) {
                    console.log("Text detect...");
                }
            },
            toolbar: [
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['font', ['strikethrough', 'superscript', 'subscript']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['height', ['height']]
            ]
        }
    )

    $('#documentos_data').DataTable({
        "aProcessing": true,
        "aServerSide": true,
        lengthChange: false,
        colReorder: true,
        buttons: [
                'copyHtml5',
                'excelHtml5',
                'csvHtml5',
                'pdfHtml5'
                ],
        "ajax":{
            url: '../../controller/documento.php?op=listar_por_tarea',
            type : "post",
            data : { id_tarea : idTarea },
            dataType : "json",
            error: function(e){
                console.log(e.responseText);
            }
        },
        "bDestroy": true,
        "bFilter": false,
        "paging": false,
        "responsive": true,
        "bInfo":false,
        "iDisplayLength": 10,
        "autoWidth": false,
        "language": {
            "sProcessing":     "Procesando...",
            "sLengthMenu":     "Mostrar _MENU_ registros",
            "sZeroRecords":    "No se encontraron resultados",
            "sEmptyTable":     "Ningún dato disponible en esta tabla",
            "sInfo":           "Mostrando un total de _TOTAL_ registros",
            "sInfoEmpty":      "Mostrando un total de 0 registros",
            "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
            "sInfoPostFix":    "",
            "sSearch":         "Buscar:",
            "sUrl":            "",
            "sInfoThousands":  ",",
            "sLoadingRecords": "Cargando...",
            "oPaginate": {
                "sFirst":    "Primero",
                "sLast":     "Último",
                "sNext":     "Siguiente",
                "sPrevious": "Anterior"
            },
            "oAria": {
                "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
                "sSortDescending": ": Activar para ordenar la columna de manera descendente"
            }
        }
    })
})

$(document).on(
    "click",
    "#btncerrartarea",
    function(){
        swal(
            {
                title : "HelpDesk",
                text : "¿Está seguro de cerrar la tarea?",
                type : "warning",
                showCancelButton : true,
                confirmButtonClass : "btn-warning",
                cancelButtonText : "No",
                closeOnConfirm : false
            },
            function(isConfirm){
                if (isConfirm) {
                    var id_tarea = getUrlParameter('ID');
                    $.post(
                        "../../controller/tarea.php?op=cerrar_tarea",
                        { id_tarea : id_tarea },
                        function(data){
                            data = JSON.parse(data)
                            console.log(data)
                            if (data.success) {
                                listardetalle(id_tarea);
                                swal({
                                    title: "Correcto!",
                                    text: "Tarea cerrada correctamente.",
                                    type: "success",
                                    confirmButtonClass: "btn-success",
                                    confirmButtonText: "Aceptar",
                                    closeOnConfirm: false,
                                    closeOnCancel: false
                                }, function() {
                                    window.history.back();
                                });
                            } else {
                                swal("Error", "Hubo un problema al cerrar la tarea.", "error");
                            }
                        }
                    )                    
                }
            }
        )
    }
)

$(document).on(
    "click",
    "#btnEnviar",
    function(){
        var respuestaTarea = $('#respTarea').val();
        
        // Se desabilita el botón y muestra Cargando...
        $('#btnEnviar').prop('disabled', true).text('Cargando...');

        // Validamos que no esten vacíos los campos
        if ($('#respTarea').summernote('isEmpty')) {
            swal(
                "Advertencia",
                "Falta respuesta",
                "warning",
            );
            $('#btnEnviar').prop('disabled', false).text('Enviar');
        } else {
            // Datos que recibe controlador
            var formData = new FormData();
            formData.append('id_tarea', idTarea);
            formData.append('id_usuario', idUsuario);
            formData.append('respuesta_tarea', respuestaTarea);
            var totalFiles = $('#fileElem').val().length;
            
            //Agregar cada archivo al formulario
            for (let index = 0; index < totalFiles; index++) {
                formData.append("files[]", $('#fileElem')[0].files[index]);
            }
            
            // Ajax para mandar los datos al controlador e insertar en BD
            $.ajax(
                {
                    url : "../../controller/tarea.php?op=insertar_respuesta",
                    type : "POST",
                    data : formData,
                    contentType: false,
                    processData: false,
                    
                    success : function(data){
                        console.log(data);
                        listardetalle(idTarea);
                        $('#respTarea').summernote('reset');
                        
                        swal({
                            title: "Correcto!",
                            text: "Registrado correctamente",
                            type: "success",
                            showCancelButton: false,
                            confirmButtonClass: "btn-success",
                            confirmButtonText: "Aceptar",
                            closeOnConfirm: true,
                            closeOnCancel: false
                        }, function(){
                            $('#btnEnviar').prop('disabled', false).text('Enviar');
                            $('#fileElem').val('');
                        });
                    },
                    
                    error : function(e){
                        console.log("Error! ", e.responseText)
                    }
                }
            )
        }
    }
)

init();