// Funcion para guardar los datos
function init(){
    $("#tarea_form").on("submit",function(e){
        guardar(e);	
    });
}

$(document).ready(function(){
    $('#viewuser').hide();
    $.ajax({
        url: '../../controller/tarea.php?op=listar',
        dataType: "json",
        success: function(data){
            $('#tarea_data').DataTable({
                data : data,
                columns : [
                    { data: 'id_tarea' },
                    { data: 'id_ticket' },
                    { data: 'usu_nom' },
                    { data: 'fecha_creacion' },
                    { data: 'tarea_titulo' },
                    { data: 'tarea_desc' },
                    { 
                        data: 'estado_tarea' ,
                        createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                            if (cellData === 1) {
                                // Si el estado es 1 significa que está abierto
                                $(cell).html('<span class="label label-pill label-success">Abierto</span>');
                            }else{
                                return data;
                            }
                        }
                    },
                    { data: 'tiempo_finalizacion' },
                    {
                        data: 'fecha_finalizacion',
                        createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                            if (cellData === null) {
                                // Si la fecha de finalización está vacía, agrega un botón amarillo
                                $(cell).html('<span class="label label-pill label-warning">Sin finalizar</span>');
                            }else{
                                return data;
                            }
                        }
                    },
                    { 
                        data: 'usuario_asignado',
                        createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                            if (cellData === null) {
                                // Si no se ah asignado, se agrega un botón rojo que manda a llamar a la función asignar con el id del elemento
                                $(cell).html('<a onClick="modal_asignar('+ rowData.id_tarea +')"class="btn btn-danger center-cell">Sin Asignar</a>');
                            }else{
                                return data;
                            }
                        }
                    },
                ],
            })
        },
        error: function(error) {
            console.error('Error al obtener datos JSON:', error);
        }
    })

    // Llenar combo de usuarios a asignar
    $.post("../../controller/usuario.php?op=combo", function (data) {
        $('#usu_asig').html(data);
    });
})

// Función para mostrar modal de tarea
function modal_asignar(id_tarea){
    $.post("../../controller/tarea.php?op=obtener", {id_tarea : id_tarea}, function(data){
        data = JSON.parse(data);
        console.log(data[0][0]);
        $('#id_tarea').val(data[0][0]);
        $('#mdltitulo').html('Asignar agente');
        $('#modalasignar').modal('show');
    });
}

// Guardar asignación de usuario
function guardar(e){
    e.preventDefault();
	var formData = new FormData($("#tarea_form")[0]);
    console.log(formData)
    $.ajax({
        url: "../../controller/tarea.php?op=asignar",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function(datos){
            /* TODO: Alerta de confirmacion */
            swal("Correcto!", "Asignado Correctamente", "success");

            /* TODO: Ocultar Modal */
            $("#modalasignar").modal('hide');

            /* TODO:Recargar Datatable JS */
            $('#tarea_data').DataTable().ajax.reload();
        }
    });
}

init();