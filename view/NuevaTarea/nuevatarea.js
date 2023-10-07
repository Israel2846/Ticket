
function init(){
    $("#tarea_form").on("submit",function(e){
        guardaryeditar(e);
    });
}

$(document).ready(function() { 
    const inputDocumentos = document.getElementById('fileElem');
    const textoError = document.getElementById('errorText');
    const btnGuardar = document.getElementById('btnGuardar');
    const tamanoMax = 3*1024*1024;

    // Restricción de tamaño de documento
    inputDocumentos.addEventListener('change', function() {
        const documentos = inputDocumentos.files;
        let tamanoTotal = 0;

        for (let index = 0; index < documentos.length; index++) {
            tamanoTotal += documentos[index].size;
        }

        if (tamanoTotal > tamanoMax) {
            textoError.textContent = 'El tamaño de los documentos es mayor al límite';
            inputDocumentos.value = '';
            btnGuardar.style.display = 'none';
        } else {
            btnGuardar.style.display = 'block';
            textoError.textContent = '';
        }
    });

    console.log($('#usu_id').val())
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
});

function guardaryeditar(e){
    e.preventDefault();

    $('#btnGuardar').prop('disabled', true).text('Cargando...')

    var tick_id = getUrlParameter('ID');
    /* TODO: Array del form tarea */
    var formData = new FormData($("#tarea_form")[0]);
    formData.append('tick_id', tick_id);
    console.log(formData);
    /* TODO: validamos si los campos tienen informacion antes de guardar */
    if ($('#tarea_desc').summernote('isEmpty') || $('#tick_id').val() == 0 || $('#usu_id').val() == 0 || $('#tarea_titulo').val() == 0){
        swal("Advertencia!", "Campos Vacios", "warning");
    }else{   
        var totalfiles = $('#fileElem').val().length;
        for (let index = 0; index < totalfiles; index++) {
            formData.append("files[]", $('#fileElem')[0].files[index]);
        }
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
                swal({
                    title: "Correcto!",
                    text: "Registrado correctamente",
                    type: "success",
                    showCancelButton: false,
                    confirmButtonClass: "btn-success",
                    confirmButtonText: "Aceptar",
                    closeOnConfirm: false,
                    closeOnCancel: false
                }, function(){
                    window.location.href = 'http://localhost/gestor-de-tickets/view/DetalleTicket/?ID=' + tick_id;
                });
            }
        });
    }
}

var getUrlParameter = function getUrlParameter(sParam) {
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
};

init();