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
                                // Si la fecha de finalización está vacía, agrega un botón azul
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
                                // Si no se ah asignado, se agrega un botón rojo
                                $(cell).html('<button class="btn btn-danger center-cell">Sin Asignar</button>');
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
})