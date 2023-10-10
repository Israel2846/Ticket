
function init(){
    $("#ticket_form").on("submit",function(e){
        guardaryeditar(e);
    });
}

$(document).ready(function() {
    const inputDocumento = document.getElementById('fileElem');
    const textoError = document.getElementById('errorFiles');
    const btnGuardar = document.getElementById('btnGuardar');
    const tamañoMax = 3*1024*1024;

    /* TODO: Inicializar SummerNote */
    $('#tick_descrip').summernote({
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

    /* TODO: Llenar Combo categoria */
    $.post("../../controller/categoria.php?op=combo",function(data, status){
        $('#cat_id').html(data);
    });

    $("#cat_id").change(function(){
        cat_id = $(this).val();
        /* TODO: llenar Combo subcategoria segun cat_id */
        $.post("../../controller/subcategoria.php?op=combo",{cat_id : cat_id},function(data, status){
            console.log(data);
            $('#cats_id').html(data);
        });
    });

    /* TODO: Llenar combo Prioridad  */
    $.post("../../controller/prioridad.php?op=combo",function(data, status){
        $('#prio_id').html(data);
    });

    // Comprobamos si los documentos no exceden el tamaño maximo
    inputDocumento.addEventListener('change', function() {
        const documentos = inputDocumento.files;
        let tamañoTotal = 0;

        for (let index = 0; index < documentos.length; index++) {
            tamañoTotal += documentos[index].size;        
        }

        if (tamañoTotal > tamañoMax) {
            textoError.textContent = 'El tamaño total de los archivos es mayor al límite';
            inputDocumento.value = '';
            btnGuardar.style.display = 'none';
        } else {
            btnGuardar.style.display = 'block'
            textoError.textContent = '';
        }
    })
});

function guardaryeditar(e){
    e.preventDefault();

    $('#btnGuardar').prop('disabled', true).text('Cargando...');

    /* TODO: Array del form ticket */
    var formData = new FormData($("#ticket_form")[0]);
    /* TODO: validamos si los campos tienen informacion antes de guardar */
    if ($('#tick_descrip').summernote('isEmpty') || $('#tick_titulo').val()=='' || $('#cats_id').val() == 0 || $('#cat_id').val() == 0 || $('#prio_id').val() == 0){
        swal("Advertencia!", "Campos Vacios", "warning");
        $('#btnGuardar').prop('disabled', false).text('Guardar');
    }else{
        var totalfiles = $('#fileElem').val().length;
        for (var i = 0; i < totalfiles; i++) {
            formData.append("files[]", $('#fileElem')[0].files[i]);
        }

        /* TODO: Guardar Ticket */
        $.ajax({
            url: "../../controller/ticket.php?op=insert",
            type: "POST",
            data: formData,
            contentType: false,
            processData: false,
            success: function(data){
                console.log(data);
                data = JSON.parse(data);
                console.log(data[0].tick_id);

                /* TODO: Envio de alerta Email de ticket Abierto */
                $.post("../../controller/email.php?op=ticket_abierto", {tick_id : data[0].tick_id}, function (data) {

                });

                /* TODO: Envio de alerta Whaspp de ticket Abierto */
                $.post("../../controller/whatsapp.php?op=w_ticket_abierto", {tick_id : data[0].tick_id}, function (data) {

                });

                /* TODO: Limpiar campos */
                $('#tick_titulo').val('');
                $('#tick_descrip').summernote('reset');
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
                    window.location.href = 'http://localhost/gestor-de-tickets/view/Home/';
                });
            }
        });
    }
}

init();