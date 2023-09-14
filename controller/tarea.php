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
}