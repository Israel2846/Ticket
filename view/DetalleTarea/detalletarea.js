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

            // Devolver el estado de la tarea con formato
            switch (data.estado_tarea) {
                case 1:
                    elem_estado = '<span class="label label-pill label-success">Abierto</span>'
                    break;
                
                case 0:
                    elem_estado = '<span class="label label-pill label-danger">Finalizado</span>'
                    break;
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
        dom: 'Bfrtip',
        "searching": true,
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
        "responsive": true,
        "bInfo":true,
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
                                swal(
                                    {
                                        title: "HelpDesk!",
                                        text: "Ticket Cerrado correctamente.",
                                        type: "success",
                                        confirmButtonClass: "btn-success"
                                    }
                                );
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

        // Validamos que no esten vacíos los campos
        if ($('#respTarea').summernote('isEmpty')) {
            swal(
                "Advertencia",
                "Falta respuesta",
                "warning",
            );
        } else {
            // Datos que recibe controlador
            var formData = new FormData();
            formData.append('id_tarea', idTarea);
            formData.append('id_usuario', idUsuario);
            formData.append('respuesta_tarea', respuestaTarea);
            var totalFiles = $('#fileElem').val().length;
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
                        swal(
                            "Correcto!",
                            "Registrado correctamente",
                            "success",
                        );
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