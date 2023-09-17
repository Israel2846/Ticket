$(document).ready(
    function(){
        // Inicialización de variables de sesión
        const usu_id = $('#user_idx').val();
        const rol_id = $('#rol_idx').val();

        // Tabla de datos
        $('#mis_tickets').DataTable(
            {
                ajax : {
                    url : '../../controller/ticket.php?op=listar_x_usu',
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
                    { "data": "tick_id" },
                    { "data": "cat_nom" },
                    { "data": "tick_titulo" },
                    { 
                        "data": "prio_nom",
                        createdCell : function(cell, cellData){
                            $(cell).html('<span class="label label-pill label-warning">'+ cellData +'</span>')
                        }
                    },
                    { 
                        "data": "tick_estado",
                        createdCell : function(cell, cellData){
                            switch (cellData) {
                                case 'Abierto':
                                    html_estado = '<span class="label label-pill label-success">'+ cellData +'</span>'
                                    break;
                                case 'En proceso':
                                    html_estado = '<span class="label label-pill label-warning">'+ cellData +'</span>'
                                    break;
                                case 'Pausado':
                                    html_estado = '<span class="label label-pill label-primary">'+ cellData +'</span>'
                                    break;
                                case 'Cerrado':
                                    html_estado = '<span class="label label-pill label-danger">'+ cellData +'</span>'
                                    break;
                            }
                            $(cell).html(html_estado)
                        }
                    },
                    { "data": "fech_crea" },
                    { "data": "fech_asig" },
                    { "data": "fech_asig" },
                    { "data": "fech_asig" },
                    { "data": "fech_asig" },
                    { "data": "fech_cierre" },
                    { 
                        "data": "usu_nom",
                        createdCell: function(cell, cellData){
                            $(cell).html('<span class="label label-pill label-success">'+ cellData +'</span>')
                        }
                    },
                    { 
                        "data": "tick_id",
                        createdCell: function (cell, cellData, rowData, rowIndex, colIndex) {
                            $(cell).html('<button type="button" onClick="ver(' + rowData.tick_id + ');"  id="' + rowData.tick_id + '" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>');
                        }
                    },
                ],
                order : []
            }
        )
    }
)