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
                        data: 'fecha_finalizacion',
                        createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                            if (cellData === null) {
                                // Si la fecha de finalización está vacía, agrega un botón rojo
                                $(cell).html('<button class="btn btn-danger center-cell">Sin Finalizar</button>');
                            }else{
                                return data;
                            }
                        }
                    },
                    { data: 'tiempo_transcurrido' }
                ],
            })
        },
        error: function(error) {
            console.error('Error al obtener datos JSON:', error);
        }
    })
})