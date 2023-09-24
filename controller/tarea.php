<?php
// Cadena de conexión
require_once("../config/conexion.php");
// Modelo Tarea
require_once("../models/Tarea.php");
$tarea = new Tarea();

require_once("../models/Documento.php");
$documento = new Documento();

// Opciones del controlador Tarea
switch($_GET["op"]){
    // Guardar/editar, si el id está vacío crea registro
    case "insert":
        $datos = $tarea->insert_tarea($_POST["usu_id"], $_POST["tick_id"], $_POST["tarea_titulo"], $_POST["tarea_desc"]);

        // Obtenemos el ID del ultimo registro insertado
        if (is_array($datos) == true and count($datos) > 0) {
            foreach ($datos as $row) {
               $output["id_tarea"] = $row["id_tarea"];
               
                // Validamos si vienen archivos desde la vista
                if (!empty($_FILES['files']['name'])) {
                    $countfiles = count($_FILES['files']['name']);

                    // Generamos ruta según el último ID registrado en la BD
                    $ruta = "../public/documentos_tareas/".$output['id_tarea']."/";
                    $files_arr = array();

                    // Si no existe la ruta se crea
                    if (!file_exists($ruta)) {
                        mkdir($ruta, 0007, true);
                    }

                    // Recorremos archivos e insertamos tantos detalles como documentos vinieron desde la vista
                    for ($i=0 ; $i < $countfiles; $i++ ) { 
                        $doc1 = $_FILES['files']['tmp_name'][$i];
                        $destino = $ruta.$_FILES['files']['name'][$i];
                        $documento -> insert_documento_tarea($output['id_tarea'], $_FILES['files']['name'][$i]);
                        move_uploaded_file($doc1, $destino);
                    }
                }
            }
        }
        break;

    case "insertar_respuesta":
        $datos = $tarea->insert_respuesta_tarea($_POST['id_tarea'], $_POST['id_usuario'], $_POST['respuesta_tarea']);
        if (is_array($datos) == true and count($datos) > 0) {
            foreach ($datos as $row) {
                $output['id_tarea'] = $row["id_tarea"];
                if (!empty($_FILES['files']['name'])) {
                    $countfiles = count($_FILES['files']['name']);
                    $ruta = "../public/documentos_respuesta_tarea/".$output['id_tarea']."/";
                    $files_arr = array();
                    if (!file_exists($ruta)) {
                        mkdir($ruta, 0777, true);
                    }
                    for ($i = 0; $i < $countfiles; $i++) { 
                        $doc1 = $_FILES['files']['tmp_name'][$i];
                        $destino = $ruta.$_FILES['files']['name'][$i];
                        $documento -> insert_documento_detalle_tarea($output['id_tarea'], $_FILES['files']['name'][$i]);
                        move_uploaded_file($doc1, $destino);
                    }
                }
            }
        }
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
                            <div class="time"><?php echo date("H:i:s", strtotime($row["fecha_crea"]));?></div>
                            <div class="cont">
                                <div class="cont-in">
                                    <p>
                                        <?php echo $row["tarea_desc"];?>
                                    </p>
                                    <br>
                                    <!-- Mostrar documentos en el las respuestas de las tareas -->
                                    <?php 
                                        $datos_tarea = $documento -> get_documento_detalle_x_tarea($row['tareadetalle_id']);
                                        if (is_array($datos_tarea) and count($datos_tarea) > 0) {
                                    ?>
                                        <p><strong>Documentos Adicionales</strong></p>

                                        <table class="table table-bordered table-striped table-vcenter js-dataTable-full">
                                            <thead>
                                                <tr>
                                                    <th style="width: 60;">Nombre</th>
                                                    <th style="width: 40;"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <?php 
                                            foreach ($datos_tarea as $dato) {
                                            ?>
                                                <tr>
                                                    <td>
                                                        <?php echo $dato['nom_det']; ?>
                                                    </td>
                                                    <td>
                                                        <a href="../public/documentos_respuesta_tarea/<?php echo $dato['id_tarea'];?>/<?php echo $dato['nom_det'];?>" target="_blank" class="btn btn-inline btn-primary btn-sm">Ver</a>
                                                    </td>
                                                </tr>
                                            <?php      
                                            }
                                            ?>
                                            </tbody>
                                        </table>
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
        break;
}