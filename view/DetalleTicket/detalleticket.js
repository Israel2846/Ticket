function init(){
   
}
const rolUsuario = $('#rol_idx').val();

$(document).ready(function(){
    const inputDocumentos = document.getElementById('fileElem');
    const textoError = document.getElementById('errorText');
    const btnEnviar = document.getElementById('btnenviar');
    const tamanoMax = 3*1024*1024;
    var tick_id = getUrlParameter('ID');
    
    // Restricción de tamaño en documentos 
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

    listardetalle(tick_id);
    ocultar_mostrar_botón_pausar();

    if (rolUsuario == 3) {
        $('#btnpausarticket').hide();
        $('#btnreanudarticket').hide();
        $('#btncerrarticket').hide();
        $('#btnNuevaTarea').hide();
    }

    /* TODO: Inicializamos summernotejs */
    $('#tickd_descrip').summernote({
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
    });

    /* TODO: Inicializamos summernotejs */
    $('#tickd_descripusu').summernote({
        height: 400,
        lang: "es-ES",
        toolbar: [
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']]
        ]
    });  

    $('#tickd_descripusu').summernote('disable');

    /* TODO: Listamos documentos en caso hubieran */
    tabla=$('#documentos_data').DataTable({
        "aProcessing": true,
        "aServerSide": true,
        lengthChange: false,
        colReorder: true,
        "ajax":{
            url: '../../controller/documento.php?op=listar',
            type : "post",
            data : {tick_id:tick_id},
            dataType : "json",
            error: function(e){
                console.log(e.responseText);
            },
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
    });

    $('#tarea_data').DataTable({
        "aProcessing": true,
        "aServerSide": true,
        lengthChange: false,
        colReorder: true,
        "ajax":{
            url: '../../controller/tarea.php?op=listar_x_ticket',
            type : 'post',
            data : {
                tick_id : tick_id
            },
            dataType: "json",
            error: function(e){
                console.log(e.responseText);
            },
            "dataSrc": ""
        },
        "columns": [
            { 
                "data": "tarea_titulo", 
                createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                    $(cell).html('<span class="label label-pill label-success">'+ cellData +'</span>')
                }
            },
            { "data": "tarea_desc" },
            { 
                "data": "estado_tarea",
                render: function (data, type, row) {
                    
                    if(data == 1) {
                        html_estado = '<span class="label label-pill label-success">Abierto</span>';
                    } else if(data == 0) {
                        html_estado = '<span class="label label-pill label-danger">Cerrado</span>';
                    }
                    
                    return html_estado
                }
            },
            { "data": "fecha_creacion" },
            { 
                "data": "fecha_finalizacion",
                render: function (data, type, row) {
                    if (data == null) {
                        return'<span class="label label-pill label-danger">Sin Finalizar</span>';
                    } else {
                        return data
                    }
                }
            },
            { 
                "data": "tiempo_finalizacion",
                render: function (data, type, row) {
                    if (data == null) {
                        return '<span class="label label-pill label-danger">Sin Finalizar</span>';
                    } else {
                        return data
                    }
                }
            },
            { 
                "data": "id_tarea" ,
                render : function(data, type, row){
                    return '<button type="button" onClick="ver(' + row.id_tarea + ');"  id="' + row.id_tarea + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>'
                }
            },
        ],
        order : [],
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
});

// Link para ver el detalle de la tarea
function ver(id_tarea){
    window.location.href = 'https://localhost/tickets-support/view/DetalleTarea/?ID='+ id_tarea +'';
}

// Click del botón "Nueva tarea"
$(document).on(
    "click",
    "#btnNuevaTarea",
    function(){
        var id_usuario = $('#user_idx').val();
        var id_ticket = getUrlParameter('ID');
        $.ajax(
            {
                url : '../../controller/tarea.php?op=tareas_abiertas',
                type : 'POST',
                data : {
                    id_usuario : id_usuario,
                },
                success : function(data){
                    data = JSON.parse(data)
                    if (data.tareas_abiertas >= 1) {
                        swal(
                            {
                                title: "HelpDesk!",
                                text: "Necesitas cerrar tus tareas antes de crear una nueva",
                                type: "warning",
                                showCancelButton: true,
                                confirmButtonClass: "btn-primary",
                                confirmButtonText: "Cerrar tareas",
                                cancelButtonText: "Cancelar",
                                closeOnConfirm: false
                            },
                            function(isConfirm){
                                if (isConfirm) {
                                    $.ajax(
                                        {
                                            url : '../../controller/tarea.php?op=cerrar_tarea_por_modal',
                                            type : 'POST',
                                            data : {
                                                id_usuario : id_usuario,
                                            },
                                            success : function(data){
                                                console.log(data)
                                                if (data == 1) {
                                                    swal({
                                                        title: "HelpDesk!",
                                                        text: "Tareas cerradas con exito",
                                                        type: "success",
                                                        confirmButtonClass: "btn-primary"
                                                    })
                                                } else {
                                                    console.log(data);
                                                }
                                            },
                                            error : function(error){
                                                console.log(error)
                                            }
                                        }
                                    )
                                }
                            }
                        )
                    } else if(data.tareas_abiertas == 0){
                        window.location.href = 'https://localhost/tickets-support/view/NuevaTarea/?ID='+ id_ticket +'';
                    }
                },
                error : function(error){
                    console.log(error)
                }
            }
        )
    }
)

// Click del botón "Pausar ticket"
$(document).on(
    "click",
    "#btnpausarticket",
    function(){
        swal({
            title: "HelpDesk",
            text: "Esta seguro de Pausar el Ticket?",
            type: "warning",
            showCancelButton: true,
            confirmButtonClass: "btn-warning",
            confirmButtonText: "Si",
            cancelButtonText: "No",
            closeOnConfirm: false
        },
        function(isConfirm) {
            if (isConfirm) {
                console.log('confirmó')
                var id_ticket = getUrlParameter('ID');
                var id_usuario = $('#user_idx').val();
                $.ajax(
                    {
                        url : '../../controller/ticket.php?op=pausar_ticket',
                        type : 'POST',
                        data : {
                            tick_id : id_ticket,
                            id_usuario : id_usuario
                        },
                        success : function(data){
                            console.log(data)
                            if (data == 1) {
                                $('#btnpausarticket').hide();
                                $('#btnreanudarticket').show();
                                $('#btnNuevaTarea').hide();
                                swal({
                                    title: "HelpDesk!",
                                    text: "Ticket Cerrado correctamente.",
                                    type: "success",
                                    confirmButtonClass: "btn-success",
                                    confirmButtonText: "Aceptar",
                                    closeOnConfirm: false,
                                    closeOnCancel: false
                                }, function() {
                                    window.location.href = 'https://localhost/tickets-support/view/MisTickets/';
                                });
                            } else {
                                console.log(data);
                            }
                        },
                        error : function(error){
                            console.log(error)
                        }
                    }
                )
            }
        })
    }
)

// Reanudar ticket
$(document).on(
    "click",
    "#btnreanudarticket",
    function(){
        swal({
            title: "HelpDesk",
            text: "Esta seguro de Reanudar el Ticket?",
            type: "warning",
            showCancelButton: true,
            confirmButtonClass: "btn-warning",
            confirmButtonText: "Si",
            cancelButtonText: "No",
            closeOnConfirm: false
        },
        function(isConfirm) {
            if (isConfirm) {
                console.log('confirmó')
                var id_ticket = getUrlParameter('ID');
                $.ajax(
                    {
                        url : '../../controller/ticket.php?op=reanudar_ticket',
                        type : 'POST',
                        data : {
                            tick_id : id_ticket,
                        },
                        success : function(data){
                            console.log(data)
                            if (data == 1) {
                                $('#btnpausarticket').show();
                                $('#btnreanudarticket').hide();
                                $('#btnNuevaTarea').show();
                                swal({
                                    title: "HelpDesk!",
                                    text: "Ticket reanudado con exito",
                                    type: "success",
                                    confirmButtonClass: "btn-primary"
                                })
                            } else {
                                console.log(data);
                            }
                        },
                        error : function(error){
                            console.log(error)
                        }
                    }
                )
            }
        })
    }
)

$(document).on("click","#btnenviar", function(){
    var tick_id = getUrlParameter('ID');
    var usu_id = $('#user_idx').val();
    var tickd_descrip = $('#tickd_descrip').val();
    
    // Se desabilita el botón y muestra cargando...
    $('#btnenviar').prop('disabled', true).text('Cargando...');

    /* TODO:Validamos si el summernote esta vacio antes de guardar */
    if ($('#tickd_descrip').summernote('isEmpty')){
        swal("Advertencia!", "Falta Descripción", "warning");
        $('#btnenviar').prop('disabled', false).text('Enviar');
    }else{
        var formData = new FormData();
        formData.append('tick_id',tick_id);
        formData.append('usu_id',usu_id);
        formData.append('tickd_descrip',tickd_descrip);
        var totalfiles = $('#fileElem').val().length;
        /* TODO:Agregamos los documentos adjuntos en caso hubiera */
        for (var i = 0; i < totalfiles; i++) {
            formData.append("files[]", $('#fileElem')[0].files[i]);
        }

        /* TODO:Insertar detalle */
        $.ajax({
            url: "../../controller/ticket.php?op=insertdetalle",
            type: "POST",
            data: formData,
            contentType: false,
            processData: false,
            success: function(data){
                console.log(data);
                listardetalle(tick_id);
                /* TODO: Limpiar inputfile */
                $('#fileElem').val('');
                $('#tickd_descrip').summernote('reset');
                
                // Se muestra notificación y regresa el botón a estado original
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
                    $('#btnenviar').prop('disabled', false).text('Enviar');
                });
            }
        });
    }
});

$(document).on("click","#btncerrarticket", function(){
    /* TODO: Preguntamos antes de cerrar el ticket */
    swal({
        title: "HelpDesk",
        text: "Esta seguro de Cerrar el Ticket?",
        type: "warning",
        showCancelButton: true,
        confirmButtonClass: "btn-warning",
        confirmButtonText: "Si",
        cancelButtonText: "No",
        closeOnConfirm: false
    },
    function(isConfirm) {
        if (isConfirm) {
            var tick_id = getUrlParameter('ID');
            var usu_id = $('#user_idx').val();
            /* TODO: Actualizamos el ticket  */
            $.post("../../controller/ticket.php?op=update", { tick_id : tick_id,usu_id : usu_id }, function (data) {
                console.log(data);
            });

            $('#tarea_data').DataTable().ajax.reload();

            /* TODO:Alerta de ticket cerrado via email */
            $.post("../../controller/email.php?op=ticket_cerrado", {tick_id : tick_id}, function (data) {

            });

            /* TODO:Alerta de ticket cerrado via Whaspp */
            $.post("../../controller/whatsapp.php?op=w_ticket_cerrado", {tick_id : tick_id}, function (data) {

            });

            /* TODO:Llamamos a funcion listardetalle */
            listardetalle(tick_id);

            /* TODO: Alerta de confirmacion */
            swal({
                title: "HelpDesk!",
                text: "Ticket Cerrado correctamente.",
                type: "success",
                confirmButtonClass: "btn-success",
                confirmButtonText: "Aceptar",
                closeOnConfirm: false,
                closeOnCancel: false
            }, function() {
                window.location.href = 'https://localhost/tickets-support/view/MisTickets/';
            });
        }
    });
});

function listardetalle(tick_id){
    /* TODO: Mostramos informacion de detalle de ticket */
    $.post("../../controller/ticket.php?op=listardetalle", { tick_id : tick_id }, function (data) {
        $('#lbldetalle').html(data);
    }); 

    /* TODO: Mostramos informacion del ticket en inputs */
    $.post("../../controller/ticket.php?op=mostrar", { tick_id : tick_id }, function (data) {
        data = JSON.parse(data);
        console.log(data);
        $('#lblestado').html(data.tick_estado);
        $('#lblnomusuario').html(data.usu_nom +' '+data.usu_ape);
        $('#lblfechcrea').html(data.fech_crea);

        $('#lblnomidticket').html("Detalle Ticket - "+data.tick_id);

        $('#cat_nom').val(data.cat_nom);
        $('#cats_nom').val(data.cats_nom);
        $('#tick_titulo').val(data.tick_titulo);
        $('#tickd_descripusu').summernote ('code',data.tick_descrip);

        $('#prio_nom').val(data.prio_nom);

        if (data.tick_estado_texto == "Cerrado"){
            /* TODO: Ocultamos panel de detalle */
            $('#pnldetalle').hide();
        }
        if (data.tick_estado_texto == "Cerrado" || data.tick_estado_texto == "Pausado"){
            /* TODO: Ocultamos panel de detalle */
            $('#btnNuevaTarea').hide();
        }
    });
}

// Listar detalle 
function ocultar_mostrar_botón_pausar(){
    var id_ticket = getUrlParameter('ID');

    $.post(
        "../../controller/ticket.php?op=obtener_ticket",
        {
            tick_id : id_ticket
        },
        function(data){
            data = JSON.parse(data);
            console.log(data.tick_estado);
            if (data.tick_estado != 'Pausado') {
                $('#btnreanudarticket').hide();
            } else {
                $('#btnpausarticket').hide();
            }
        }
    )
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
