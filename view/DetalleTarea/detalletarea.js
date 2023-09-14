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

function listardetalle(id_tarea){
    // Mostramos información del detalle de la tearea
    /* $.post(
        "../../controller/tarea.php?op=listardetalle",
        {id_tarea : id_tarea},
        function(data){
            $('#lbldetalle').html(data);
        }
    ) */

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
                $('#btncerrartarea').hide();
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
    var id_tarea = getUrlParameter('ID');
    listardetalle(id_tarea)

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

    $('#tarea_descrip').summernote(
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
                    // var usu_id = $('#user_idx').val();
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

init();