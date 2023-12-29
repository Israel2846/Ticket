// Funcion para guardar los datos
function init(){
    $("#tarea_form").on("submit",function(e){
        guardar(e);	
    });
}

$(document).ready(function(){
    $('#viewuser').hide();
    $('#tarea_data').DataTable({
        "ajax":{
            url: '../../controller/tarea.php?op=listar',
            dataType: "json",
            error: function(e){
                console.log(e.responseText);
            },
            "dataSrc": ""
        },
        "columns": [
            { "data": "id_tarea" },
            { "data": "id_ticket" },
            { "data": "usu_nom" },
            { "data": "fecha_creacion" },
            { "data": "tarea_titulo" },
            { "data": "tarea_desc" },
            {
                "data": 'estado_tarea' ,
                render: function (data, type, row) {
                    if (data == 1) {
                        // Si el estado es 1 significa que está abierto
                        return '<span class="label label-pill label-success">Abierto</span>';
                    }else if(data==0){
                        return '<span class="label label-pill label-danger">Cerrado</span>';
                    }
                }
            },
            { "data": 'tiempo_finalizacion' },
            {
                "data": 'fecha_finalizacion',
                render: function (data, type, row) {
                    if (data == null) {
                        // Si la fecha de finalización está vacía, agrega un botón amarillo
                        return'<span class="label label-pill label-danger">Sin finalizar</span>';
                    }else{
                        return data;
                    }
                }
            },
            { 
                "data": 'id_tarea',
                render: function (data, type, row) {
                    return '<button type="button" onClick="ver(' + row.id_tarea + ');"  id="' + row.id_tarea + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>';
                }
            }
        ],
        order : [],
        "bPaginate": true,
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

// Función para mostrar modal de tarea
function modal_asignar(id_tarea){
    $.post("../../controller/tarea.php?op=obtener", {id_tarea : id_tarea}, function(data){
        data = JSON.parse(data);
        console.log(data.id_tarea);
        $('#id_tarea').val(data.id_tarea);
        $('#mdltitulo').html('Asignar agente');
        $('#modalasignar').modal('show');
    });
}

// Guardar asignación de usuario
function guardar(e){
    e.preventDefault();
    var id_tarea = $("#id_tarea").val();
    var usu_asig = $("#usu_asig").val();
    var datos = {
        id_tarea: id_tarea,
        usu_asig: usu_asig,
    };
    
    $.ajax({
        url: "../../controller/tarea.php?op=asignar",
        type: "POST",
        data: datos,
        success: function(respuesta){
            /* TODO: Alerta de confirmacion */
            swal("Correcto!", "Asignado Correctamente", "success")

            /* TODO: Ocultar Modal */
            $("#modalasignar").modal('hide');

            /* TODO:Recargar datatable js */
            $('#tarea_data').DataTable().ajax.reload();
        },
        error: function(error){
            console.error('Error en la solicitud AJAX:', error);
        }
    });
}

// Link para ver el detalle de la tarea
function ver(id_tarea){
    window.open('https://localhost/tickets-support/view/DetalleTarea/?ID='+ id_tarea +'');
}

init();