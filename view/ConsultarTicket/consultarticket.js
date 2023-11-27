const usu_id =  $('#user_idx').val();
const rol_id =  $('#rol_idx').val();

function init(){
    $("#ticket_form").on("submit",function(e){
        guardar(e);	
    });
}

$(document).ready(function(){
    // Inicializamos datatables
    datatable_abiertos();
    datatable_en_proceso();
    datatable_pausado();
    datatable_cerrado();

    /* TODO: Llenar Combo Categoria */
    $.post("../../controller/categoria.php?op=combo",function(data, status){
        $('#cat_id').html(data);
    });

    /* TODO: llenar Combo Prioridad */
    $.post("../../controller/prioridad.php?op=combo",function(data, status){
        $('#prio_id').html(data);
    });

    /* TODO:LLenar Combo usuario asignar */
    $.post("../../controller/usuario.php?op=combo", function (data) {
        $('#usu_asig').html(data);
    });

    // Intervalo de tiempo para actualizar datatables
    setInterval(function(){
        console.log('Recarga datatables');
        $('#ticket_abierto').DataTable().ajax.reload();
        $('#ticket_en_proceso').DataTable().ajax.reload();
        $('#ticket_pausado').DataTable().ajax.reload();
        $('#ticket_cerrado').DataTable().ajax.reload();
    }, 90000);
});

/* TODO: Link para poder ver el detalle de ticket en otra ventana */
function ver(tick_id){
    window.location.href = 'http://localhost/Ticket/view/DetalleTicket/?ID='+ tick_id +'';
}

/* TODO: Mostrar datos antes de asignar */
function asignar(tick_id){
    $.post("../../controller/ticket.php?op=mostrar", {tick_id : tick_id}, function (data) {
        data = JSON.parse(data);
        $('#tick_id').val(data.tick_id);

        $('#mdltitulo').html('Asignar Agente');
        $("#modalasignar").modal('show');
    });
}

/* TODO: Guardar asignacion de usuario de soporte */
function guardar(e){
    e.preventDefault();
	var formData = new FormData($("#ticket_form")[0]);
    console.log(formData);
    $.ajax({
        url: "../../controller/ticket.php?op=asignar",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function(datos){
            var tick_id = $('#tick_id').val();
            /* TODO: enviar Email de alerta de asignacion */
            $.post("../../controller/email.php?op=ticket_asignado", {tick_id : tick_id}, function (data) {

            });

            /* TODO: enviar Whaspp de alerta de asignacion */
            $.post("../../controller/whatsapp.php?op=w_ticket_asignado", {tick_id : tick_id}, function (data) {

            });

            /* TODO: Alerta de confirmacion */
            swal("Correcto!", "Asignado Correctamente", "success");

            /* TODO: Ocultar Modal */
            $("#modalasignar").modal('hide');
            /* TODO:Recargar Datatable abierto JS */
            $('#ticket_abierto').DataTable().ajax.reload();
            // Recargar datatable en proceso
            $('#ticket_en_proceso').DataTable().ajax.reload();
            // Recargar datatable pausado
            $('#ticket_pausado').DataTable().ajax.reload();
            // Recargar datatable cerrado
            $('#ticket_cerrado').DataTable().ajax.reload();
        }
    });
}

/* TODO:Reabrir ticket */
function CambiarEstado(tick_id){
    swal({
        title: "HelpDesk",
        text: "Esta seguro de Reabrir el Ticket?",
        type: "warning",
        showCancelButton: true,
        confirmButtonClass: "btn-warning",
        confirmButtonText: "Si",
        cancelButtonText: "No",
        closeOnConfirm: false
    },
    function(isConfirm) {
        if (isConfirm) {
            /* TODO: Enviar actualizacion de estado */
            $.post("../../controller/ticket.php?op=reabrir", {tick_id : tick_id,usu_id : usu_id}, function (data) {

            });

            /* TODO:Recargar datatable js */
            $('#ticket_data').DataTable().ajax.reload();	

            /* TODO: Mensaje de Confirmacion */
            swal({
                title: "HelpDesk!",
                text: "Ticket Abierto.",
                type: "success",
                confirmButtonClass: "btn-success"
            });
        }
    });
}

/* TODO:Filtro avanzado */
$(document).on("click","#btnfiltrar", function(){
    limpiar();

    var tick_titulo = $('#tick_titulo').val();
    var cat_id = $('#cat_id').val();
    var prio_id = $('#prio_id').val();

    listardatatable(tick_titulo,cat_id,prio_id);

});

/* TODO: Restaurar Datatable js y limpiar */
$(document).on("click","#btntodo", function(){
    limpiar();

    $('#tick_titulo').val('');
    $('#cat_id').val('').trigger('change');
    $('#prio_id').val('').trigger('change');

    listardatatable('','','');
});

/* TODO: Listar datatable con filtro avanzado */
function datatable_abiertos(){
    $('#ticket_abierto').dataTable(
        {
            "aProcessing": true,
            "aServerSide": true,
            lengthChange: false,
            colReorder: true,
            "ajax" : {
                url : '../../controller/ticket.php?op=listar_ticket_abierto',
                dataType : "json",
                error: function(e){
                    console.log(e.responseText);
                },
                "dataSrc": ""
            },
            "columns" : [
                { 
                    "data": "tick_id" ,
                    render: function(data, type, row) {
                        return '<span class="label label-pill label-success">' + data + '</span>'
                    }
                },
                { "data": "cat_nom" },
                { "data": "tick_titulo" },
                { "data": "prio_nom" },
                { 
                    "data": "tick_estado",
                    render : function(data){
                        return '<span class="label label-pill label-success">' + data + '</span>'
                    }
                },
                { "data": "fech_crea" },
                // { "data": "fech_asig" },
                // { "data": "timeresp" },
                { "data": "timetransc" },
                // { "data": "tiempototal" },
                // { "data": "fech_cierre" },
                { 
                    "data": "usu_id",
                    render : function(data, type, row){
                        return '<span class="label label-pill label-success">' + row.usu_nom +'</span>'
                    }
                },
                { "data" : "nombre_almacen" },
                { "data" : "nombre_area" },
                { 
                    "data": "tick_id" ,
                    render : function(data, type, row){
                        if (row.usu_asig == null) {
                            return '<button type="button" onClick="asignar(' + row.tick_id + ');"  id="' + row.tick_id + '" class="btn btn-inline btn-danger btn-sm ladda-button">Sin asignar</i></button>'
                        } else {
                            return row.asignado
                        }
                    }
                },
                { 
                    "data": "tick_id" ,
                    render : function(data, type, row){
                        return '<button type="button" onClick="ver(' + row.tick_id + ');"  id="' + row.tick_id + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>'
                    }
                },
            ],
            order : [],
            "bDestroy": true,
            "bFilter": false,
            "paging": true,
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
        }
    )
}

function datatable_en_proceso(){
    $('#ticket_en_proceso').dataTable(
        {
            "aProcessing": true,
            "aServerSide": true,
            lengthChange: false,
            colReorder: true,
            "ajax" : {
                url : '../../controller/ticket.php?op=listar_ticket_en_proceso',
                dataType : "json",
                error: function(e){
                    console.log(e.responseText);
                },
                "dataSrc": ""
            },
            "columns" : [
                { 
                    "data": "tick_id" ,
                    render: function(data, type, row) {
                        return '<span class="label label-pill label-warning">' + data + '</span>'
                    }
                },
                { "data": "cat_nom" },
                { "data": "tick_titulo" },
                { "data": "prio_nom" },
                { 
                    "data": "tick_estado",
                    render : function(data){
                        return '<span class="label label-pill label-warning">' + data + '</span>'
                    }
                },
                { "data": "fech_crea" },
                { "data": "fech_asig" },
                { "data": "timeresp" },
                { "data": "timetransc" },
                // { "data": "tiempototal" },
                // { "data": "fech_cierre" },
                { 
                    "data": "usu_id",
                    render : function(data, type, row){
                        return '<span class="label label-pill label-success">' + row.usu_nom +'</span>'
                    }
                },
                { 
                    "data": "tick_id" ,
                    render : function(data, type, row){
                        if (row.usu_asig == null) {
                            return '<button type="button" onClick="asignar(' + row.tick_id + ');"  id="' + row.tick_id + '" class="btn btn-inline btn-danger btn-sm ladda-button">Sin asignar</i></button>'
                        } else {
                            return row.asignado
                        }
                    }
                },
                { 
                    "data": "tick_id" ,
                    render : function(data, type, row){
                        return '<button type="button" onClick="ver(' + row.tick_id + ');"  id="' + row.tick_id + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>'
                    }
                },
            ],
            order : [],
            "bDestroy": true,
            "bFilter": false,
            "paging": true,
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
        }
    )
}

function datatable_pausado(){
    $('#ticket_pausado').dataTable(
        {
            "aProcessing": true,
            "aServerSide": true,
            lengthChange: false,
            colReorder: true,
            "ajax" : {
                url : '../../controller/ticket.php?op=listar_ticket_pausado',
                dataType : "json",
                error: function(e){
                    console.log(e.responseText);
                },
                "dataSrc": ""
            },
            "columns" : [
                { 
                    "data": "tick_id" ,
                    render: function(data, type, row) {
                        return '<span class="label label-pill label-primary">' + data + '</span>'
                    }
                },
                { "data": "cat_nom" },
                { "data": "tick_titulo" },
                { "data": "prio_nom" },
                { 
                    "data": "tick_estado",
                    render : function(data){
                        return '<span class="label label-pill label-primary">' + data + '</span>'
                    }
                },
                { "data": "fech_crea" },
                { "data": "fech_asig" },
                { "data": "timeresp" },
                { "data": "timetransc" },
                // { "data": "tiempototal" },
                // { "data": "fech_cierre" },
                { 
                    "data": "usu_id",
                    render : function(data, type, row){
                        return '<span class="label label-pill label-success">' + row.usu_nom +'</span>'
                    }
                },
                { 
                    "data": "tick_id" ,
                    render : function(data, type, row){
                        if (row.usu_asig == null) {
                            return '<button type="button" onClick="asignar(' + row.tick_id + ');"  id="' + row.tick_id + '" class="btn btn-inline btn-danger btn-sm ladda-button">Sin asignar</i></button>'
                        } else {
                            return row.asignado
                        }
                    }
                },
                { 
                    "data": "tick_id" ,
                    render : function(data, type, row){
                        return '<button type="button" onClick="ver(' + row.tick_id + ');"  id="' + row.tick_id + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>'
                    }
                },
            ],
            order : [],
            "bDestroy": true,
            "bFilter": false,
            "paging": true,
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
        }
    )
}

function datatable_cerrado(){
    $('#ticket_cerrado').dataTable(
        {
            "aProcessing": true,
            "aServerSide": true,
            lengthChange: false,
            colReorder: true,
            "ajax" : {
                url : '../../controller/ticket.php?op=listar_ticket_cerrado',
                dataType : "json",
                error: function(e){
                    console.log(e.responseText);
                },
                "dataSrc": ""
            },
            "columns" : [
                { 
                    "data": "tick_id" ,
                    render: function(data, type, row) {
                        return '<span class="label label-pill label-danger">' + data + '</span>'
                    }
                },
                { "data": "cat_nom" },
                { "data": "tick_titulo" },
                { "data": "prio_nom" },
                { 
                    "data": "tick_estado",
                    render : function(data){
                        return '<span class="label label-pill label-danger">' + data + '</span>'
                    }
                },
                { "data": "fech_crea" },
                { "data": "fech_asig" },
                { "data": "timeresp" },
                { "data": "tiempototal" },
                { "data": "fech_cierre" },
                { 
                    "data": "usu_id",
                    render : function(data, type, row){
                        return '<span class="label label-pill label-success">' + row.usu_nom +'</span>'
                    }
                },
                { 
                    "data": "tick_id" ,
                    render : function(data, type, row){
                        if (row.usu_asig == null) {
                            return '<button type="button" onClick="asignar(' + row.tick_id + ');"  id="' + row.tick_id + '" class="btn btn-inline btn-danger btn-sm ladda-button">Sin asignar</i></button>'
                        } else {
                            return row.asignado
                        }
                    }
                },
                { 
                    "data": "tick_id" ,
                    render : function(data, type, row){
                        return '<button type="button" onClick="ver(' + row.tick_id + ');"  id="' + row.tick_id + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>'
                    }
                },
            ],
            order : [],
            "bDestroy": true,
            "bFilter": false,
            "paging": true,
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
        }
    )
}

/* TODO: Limpiamos restructurando el html del datatable js */
function limpiar(){
    $('#table').html(
        "<table id='ticket_data' class='table table-bordered table-striped table-vcenter js-dataTable-full'>"+
            "<thead>"+
                "<tr>"+
                    "<th style='width: 5%;'>Nro.Ticket</th>"+
                    "<th style='width: 15%;'>Categoria</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 30%;'>Titulo</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 5%;'>Prioridad</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 5%;'>Estado</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 10%;'>Fecha Creación</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 10%;'>Fecha Asignación</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 5%;'>T. Respuesta</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 5%;'>T. Transcurrido</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 5%;'>T. Tarea</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 5%;'>T. Total</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 10%;'>Fecha Cierre</th>"+
                    "<th class='d-none d-sm-table-cell' style='width: 10%;'>Soporte</th>"+
                    "<th class='text-center' style='width: 5%;'></th>"+
                "</tr>"+
            "</thead>"+
            "<tbody>"+

            "</tbody>"+
        "</table>"
    );
}

init();