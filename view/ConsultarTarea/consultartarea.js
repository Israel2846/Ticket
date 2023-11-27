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
                createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                    if (cellData === 1) {
                        // Si el estado es 1 significa que está abierto
                        $(cell).html('<span class="label label-pill label-success">Abierto</span>');
                    }else if(cellData===0){
                        $(cell).html('<span class="label label-pill label-danger">Cerrado</span>');
                    }
                }
            },
            { "data": 'tiempo_finalizacion' },
            {
                "data": 'fecha_finalizacion',
                createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                    if (cellData === null) {
                        // Si la fecha de finalización está vacía, agrega un botón amarillo
                        $(cell).html('<span class="label label-pill label-danger">Sin finalizar</span>');
                    }else{
                        $(cell).html(cellData);
                    }
                }
            },
            { 
                "data": 'id_tarea',
                createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                    $(cell).html('<button type="button" onClick="ver(' + rowData.id_tarea + ');"  id="' + rowData.id_tarea + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>');
                }
            }
        ]
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
    window.open('http://localhost/Ticket/view/DetalleTarea/?ID='+ id_tarea +'');
}

init();