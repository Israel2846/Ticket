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
            datos = {
                id_tarea : idTarea,
                id_usuario : idUsuario,
                respuesta_tarea : respuestaTarea
            }

            // Ajax para mandar los datos al controlador e insertar en BD
            $.ajax(
                {
                    url : "../../controller/tarea.php?op=insertar_respuesta",
                    type : "POST",
                    data : datos,
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