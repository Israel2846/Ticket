<?php
// Cadena de conexión
require_once("../config/conexion.php");
// Modelo Tarea
require_once("../models/Tarea.php");
$tarea = new Tarea();

// Opciones del controlador Tarea
switch($_GET["op"]){
    // Guardar/editar, si el id está vacío crea registro
    case "insert":
        $tarea->insert_tarea($_POST["usu_id"], $_POST["tick_id"], $_POST["tarea_titulo"], $_POST["tarea_desc"]);
        break;

    case "listar":
        $datos = $tarea->listar_tareas();        
        echo json_encode($datos);
        break;

    case "listar_x_ticket":
        $datos = $tarea->listar_tareas_x_ticket($_POST['tick_id']);
        echo json_encode($datos);
        break;

    case "obtener":
        $datos = $tarea->get_tarea($_POST['id_tarea']);
        echo json_encode($datos);
        break;

    case "asignar":
        $datos = $tarea->assign_tarea($_POST['id_tarea'], $_POST['usu_asig']);
        break;

    case "cerrar_tarea":
        $tarea->close_tarea($_POST['id_tarea']);
        break;

    case "cerrar_tarea_por_modal":
        $respuesta = $tarea->close_tareas_x_modal($_POST['id_usuario']);
        echo $respuesta;
        break;

    case "tareas_abiertas":
        $datos = $tarea->count_tareas_abiertas($_POST['id_usuario']);
        echo json_encode($datos);
        break;

    case "insertar_respuesta":
        $respuesta = $tarea->insert_respuesta_tarea($_POST['id_tarea'], $_POST['id_usuario'], $_POST['respuesta_tarea']);
        echo $respuesta;
        break;

    case "listar_respuestas":
        $datos = $tarea->listar_respuestas_tarea($_POST['id_tarea']);
        ?>
        <!-- Iteramos sobre los datos obtenidos en la consulta -->
            <?php foreach ($datos as $row) { ?>
                <article class="activity-line-item box-typical">
                    <div class="activity-line-date">
                        <!-- TODO: Formato de fecha creacion -->
                        <?php echo date("d/m/Y", strtotime($row["fecha_crea"]));?>
                    </div>
                    <header class="activity-line-item-header">
                        <div class="activity-line-item-user">
                            <div class="activity-line-item-user-photo">
                                <a href="#">
                                    <img src="../../public/<?php echo $row['rol_id'] ?>.jpg" alt="">
                                </a>
                            </div>
                            <div class="activity-line-item-user-name"><?php echo $row['usu_nom'].' '.$row['usu_ape'];?></div>
                            <div class="activity-line-item-user-status">
                                <!-- TODO: Mostrar perfil del usuario segun rol -->
                                <?php
                                    if ($row['rol_id']==1) {
                                        echo 'Soporte';
                                    } else if($row['rol_id']==2) {
                                        echo 'Admin';
                                    } else {
                                        echo 'Usuario';
                                    }
                                ?>
                            </div>
                        </div>
                    </header>
                    <div class="activity-line-action-list">
                        <section class="activity-line-action">
                            <div class="time"><?php echo date("H:i:s", strtotime($row["fech_crea"]));?></div>
                            <div class="cont">
                                <div class="cont-in">
                                    <p>
                                        <?php echo $row["tickd_descrip"];?>
                                    </p>

                                    <br>

                                    <!-- TODO: Mostrar documentos adjunto en el detalle de ticket -->
                                    <?php
                                        $datos_det=$documento->get_documento_detalle_x_ticketd($row["tickd_id"]);
                                        if(is_array($datos_det)==true and count($datos_det)>0){
                                            ?>
                                                <p><strong>Documentos Adicionales</strong></p>

                                                <p>
                                                <table class="table table-bordered table-striped table-vcenter js-dataTable-full">
                                                    <thead>
                                                        <tr>
                                                            <th style="width: 60%;"> Nombre</th>
                                                            <th style="width: 40%;"></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                            <!-- TODO: Mostrar tantos documentos tenga el ticket detalle -->
                                                            <?php
                                                                foreach ($datos_det as $row_det){ 
                                                            ?>
                                                                <tr>
                                                                    <td><?php echo $row_det["det_nom"]; ?></td>
                                                                    <td>
                                                                        <a href="../../public/document_detalle/<?php echo $row_det["tickd_id"]; ?>/<?php echo $row_det["det_nom"]; ?>" target="_blank" class="btn btn-inline btn-primary btn-sm">Ver</a>
                                                                    </td>
                                                                </tr>
                                                            <?php
                                                                }
                                                            ?>
                                                    </tbody>
                                                </table>

                                                </p>
                                            <?php
                                        }
                                    ?>
                                </div>
                            </div>
                        </section>
                    </div>
                </article>
            <?php } ?>
        <?php
}