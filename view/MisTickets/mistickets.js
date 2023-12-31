 // Inicializaci��n de variables de sesi��n
const usu_id = $('#user_idx').val();
const rol_id = $('#rol_idx').val();
var url = '';

if (rol_id == 1 || rol_id == 2) {
    url = '../../controller/ticket.php?op=listar_x_usu'
} else if(rol_id == 3){
    url = '../../controller/ticket.php?op=listar_x_creador';
} else {
    console.log('Error al consultar');
}

$(document).ready(function(){
    // Tabla de datos
    $('#mis_tickets').DataTable({
        "aProcessing": true,
        "aServerSide": true,
        lengthChange: false,
        colReorder: true,
        ajax : {
            url : url,
            type : 'POST',
            data : {
                usu_id : usu_id
            },
            dataType : 'json',
            error : function(e){
                console.log(e.responseText);
            },
            dataSrc : ""
        },
        columns : [
            { 
                "data": "tick_id",
                render: function(data, type, row){
                    if (row.tick_estado == 'Abierto') {
                        return '<span class="label label-pill label-success">'+ data +'</span>';
                    } else if( row.tick_estado == 'En proceso') {
                        return '<span class="label label-pill label-warning">'+ data +'</span>';
                    } else if( row.tick_estado == 'Pausado') {
                        return '<span class="label label-pill label-primary">'+ data +'</span>';
                    } else if( row.tick_estado == 'Cerrado') {
                        return '<span class="label label-pill label-danger">'+ data +'</span>';
                    } else {
                        return 'Error'
                    }
                }
            },
            { "data": "cat_nom" },
            { "data": "tick_titulo" },
            { 
                "data": "prio_nom",
                render : function (data, type, row) {
                    return '<span class="label label-pill label-warning">'+ data +'</span>'
                }
            },
            { 
                "data": "tick_estado",
                render : function(data, type, row){
                    switch (data) {
                        case 'Abierto':
                            html_estado = '<span class="label label-pill label-success">'+ data +'</span>';
                            break;
                        case 'En proceso':
                            html_estado = '<span class="label label-pill label-warning">'+ data +'</span>'
                            break;
                        case 'Pausado':
                            html_estado = '<span class="label label-pill label-primary">'+ data +'</span>'
                            break;
                        case 'Cerrado':
                            html_estado = '<span class="label label-pill label-danger">'+ data +'</span>'
                            break;
                    }
                    return html_estado;
                }
            },
            { "data": "fech_crea" },
            { "data": "fech_asig" },
            { "data": "timeresp" },
            { 
                "data": "timetransc" ,
                render: function(data, type, row){
                    if (row.tick_estado == 'Cerrado') {
                        return '<span class="label label-pill label-danger">Ticket cerrado</span>';
                    } else {
                        return data;
                    }
                }
            },
            { "data": "tiempototal" },
            { "data": "fech_cierre" },
            { 
                "data": "usu_nom",
                render : function(data, type, row){
                    var elemento = '<span class="label label-pill label-success">'+ data +'</span>';
                    return elemento;
                }
            },
            { 
                "data": "tick_id",
                render: function (data, type, row) {
                    var buttonHtml = '<button type="button" onClick="ver(' + data + ');"  id="' + data + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></button>';
                    return buttonHtml;
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
            "sEmptyTable":     "Ning��n dato disponible en esta tabla",
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
                "sLast":     "�0�3ltimo",
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

function ver(tick_id){
    window.location.href = 'https://localhost/tickets-support/view/DetalleTicket/?ID='+ tick_id +'';
}