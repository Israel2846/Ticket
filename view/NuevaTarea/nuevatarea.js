
function init(){
    $("#tarea_form").on("submit",function(e){
        guardaryeditar(e);
    });
}

$(document).ready(function() { 
    /* TODO: Inicializar SummerNote */
    $('#tarea_desc').summernote({
        height: 150,
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
    });
    
    /* TODO: Llenar Combo ticket */
    $.post("../../controller/ticket.php?op=combo",function(data, status){
        $('#tick_id').html(data);
    });
});

function guardaryeditar(e){
    e.preventDefault();
    /* TODO: Array del form ticket */
    var formData = new FormData($("#tarea_form")[0]);
    /* TODO: validamos si los campos tienen informacion antes de guardar */
    if ($('#tarea_desc').summernote('isEmpty') || $('#tick_id').val() == 0 || $('#tarea_titulo').val() == 0){
        swal("Advertencia!", "Campos Vacios", "warning");
    }else{        
        /* TODO: Guardar Ticket */
        $.ajax({
            url: "../../controller/tarea.php?op=insert",
            type: "POST",
            data: formData,
            contentType: false,
            processData: false,
            success: function(data){
                console.log(data);
                /* TODO: Limpiar campos */
                $('#tick_id').val('');
                $('#tarea_titulo').val('');
                $('#tarea_desc').summernote('reset');
                /* TODO: Alerta de Confirmacion */
                swal("Correcto!", "Registrado Correctamente", "success");
            }
        });
    }
}

init();