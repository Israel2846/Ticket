function init(){
   
}

$(document).ready(function(){
    var tick_id = getUrlParameter('ID');

    listardetalle(tick_id);
    ocultar_mostrar_botón_pausar();

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
    tabla=$('#documentos_data').dataTable({
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
            url: '../../controller/documento.php?op=listar',
            type : "post",
            data : {tick_id:tick_id},
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
    }).DataTable();

    $('#tarea_data').DataTable({
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
                createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                    switch (cellData) {
                        case 1:
                            html_estado = '<span class="label label-pill label-success">Abierto</span>';
                            break;
                        case 0:
                            html_estado = '<span class="label label-pill label-danger">Cerrado</span>';
                            break;
                    }
                    $(cell).html(html_estado)
                }
            },
            { "data": "fecha_creacion" },
            { 
                "data": "fecha_finalizacion",
                createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                    if (cellData == null) {
                        $(cell).html('<span class="label label-pill label-danger">Sin Finalizar</span>')
                    } else {
                        $(cell).html(cellData)
                    }
                }
            },
            { 
                "data": "tiempo_finalizacion",
                createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                    if (cellData == null) {
                        $(cell).html('<span class="label label-pill label-danger">Sin Finalizar</span>')
                    } else {
                        $(cell).html(cellData)
                    }
                }
            },
            { 
                "data": "id_tarea" ,
                createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                    $(cell).html('<button type="button" onClick="ver(' + rowData.id_tarea + ');"  id="' + rowData.id_tarea + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>');
                }
            },
        ],
        order : [],
    })
});

// Link para ver el detalle de la tarea
function ver(id_tarea){
    window.location.href = 'http://localhost:80/gestor-de-tickets/view/DetalleTarea/?ID='+ id_tarea +'';
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
                    id_ticket : id_ticket,
                },
                success : function(data){
                    data = JSON.parse(data)
                    if (data.tareas_abiertas >= 1) {
                        swal({
                            title: "HelpDesk!",
                            text: "Necesitas cerrar tus tareas antes de crear una nueva",
                            type: "warning",
                            confirmButtonClass: "btn-primary"
                        })
                    } else if(data.tareas_abiertas === 0){
                        window.location.href = 'http://localhost:80/gestor-de-tickets/view/NuevaTarea/?ID='+ id_ticket +'';
                    } else {
                        console.log("Error");
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
                $.ajax(
                    {
                        url : '../../controller/ticket.php?op=pausar_ticket',
                        type : 'POST',
                        data : {
                            tick_id : id_ticket,
                        },
                        success : function(data){
                            console.log(data)
                            if (data == 1) {
                                $('#btnpausarticket').hide();
                                $('#btnreanudarticket').show();
                                swal({
                                    title: "HelpDesk!",
                                    text: "Tarea pausada con exito",
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
                                swal({
                                    title: "HelpDesk!",
                                    text: "Tarea reanudada con exito",
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

$(document).on("click","#btnenviar", function(){
    var tick_id = getUrlParameter('ID');
    var usu_id = $('#user_idx').val();
    var tickd_descrip = $('#tickd_descrip').val();

    /* TODO:Validamos si el summernote esta vacio antes de guardar */
    if ($('#tickd_descrip').summernote('isEmpty')){
        swal("Advertencia!", "Falta Descripción", "warning");
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
                swal("Correcto!", "Registrado Correctamente", "success");
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

            });

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
                confirmButtonClass: "btn-success"
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

init();
