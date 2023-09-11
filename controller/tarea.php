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
}