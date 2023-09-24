function init(){

}

$(document).ready(function(){
    var usu_id = $('#user_idx').val();
    const usu_rol = $('#rol_idx').val();

    /* TODO: Llenar graficos segun rol  */
    if ( usu_rol == 1 || usu_rol == 3){
        $.post("../../controller/usuario.php?op=total", {usu_id:usu_id, usu_rol : usu_rol}, function (data) {
            data = JSON.parse(data);
            $('#lbltotal').html(data.TOTAL);
        }); 

        $.post("../../controller/usuario.php?op=totalabierto", {usu_id:usu_id, usu_rol : usu_rol}, function (data) {
            data = JSON.parse(data);
            $('#lbltotalabierto').html(data.TOTAL);
        });

        $.post("../../controller/usuario.php?op=totalcerrado", {usu_id:usu_id, usu_rol : usu_rol}, function (data) {
            data = JSON.parse(data);
            $('#lbltotalcerrado').html(data.TOTAL);
        });

        $.post("../../controller/usuario.php?op=grafico", {usu_id:usu_id, usu_rol : usu_rol},function (data) {
            data = JSON.parse(data);

            new Morris.Bar({
                element: 'divgrafico',
                data: data,
                xkey: 'nom',
                ykeys: ['total'],
                labels: ['Value'],
                barColors: ["#1AB244"], 
            });
        }); 

    }else{
        $.post("../../controller/ticket.php?op=total",function (data) {
            data = JSON.parse(data);
            $('#lbltotal').html(data.TOTAL);
        });

        $.post("../../controller/ticket.php?op=totalabierto",function (data) {
            data = JSON.parse(data);
            $('#lbltotalabierto').html(data.TOTAL);
        });

        $.post("../../controller/ticket.php?op=totalcerrado", function (data) {
            data = JSON.parse(data);
            $('#lbltotalcerrado').html(data.TOTAL);
        });

        $.post("../../controller/ticket.php?op=grafico",function (data) {
            data = JSON.parse(data);

            new Morris.Bar({
                element: 'divgrafico',
                data: data,
                xkey: 'nom',
                ykeys: ['total'],
                labels: ['Value']
            });
        });

    }
});

init();