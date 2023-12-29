<?php
require_once("../../config/conexion.php");
if(isset($_SESSION["usu_id"])){
?>
<!DOCTYPE html>
<html>
<head>
    <?php require_once("../MainHead/head.php");?>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Tarea</title>
    <link rel="stylesheet" href="css/separate/vendor/tags_editor.min.css">
	<link rel="stylesheet" href="css/separate/vendor/bootstrap-select/bootstrap-select.min.css">
	<link rel="stylesheet" href="css/separate/vendor/select2.min.css">
    <link rel="stylesheet" href="css/lib/font-awesome/font-awesome.min.css">
    <link rel="stylesheet" href="css/lib/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="css/main.css">
</head>
<body class="with-side-menu">
    <?php require_once("../MainHeader/header.php");?>
    <div class="mobile-menu-left-overlay"></div>
    <?php require_once("../MainNav/nav.php");?>

    <!-- Contenido -->
    <div class="page-content">
		<div class="container-fluid">

			<header class="section-header">
				<div class="tbl">
					<div class="tbl-row">
						<div class="tbl-cell">
							<h3>Nueva Tarea</h3>
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="../Home/">Inicio</a></li>
								<li class="active">Nueva Tarea</li>
							</ol>
						</div>
					</div>
				</div>
			</header>

			<div class="box-typical box-typical-padding">
				<p>
					Desde esta ventana podra generar nuevas tareas de HelpDesk.
				</p>

				<h5 class="m-t-lg with-border">Ingresar Información</h5>

				<div class="row">
					<form method="post" id="tarea_form">

						<input type="hidden" id="usu_id" name="usu_id" value="<?php echo $_SESSION["usu_id"] ?>">						

						<div class="col-lg-6">
							<fieldset class="form-group">
								<label class="form-label semibold" for="tarea_titulo">Título</label>
								<input type="text" name="tarea_titulo" id="tarea_titulo" class="form-control" placeholder="Escriba aquí el título de la tarea">
							</fieldset>
						</div>

						<div class="col-lg-6">
							<fieldset class="form-group">
								<label class="form-label semibold" for="tarea_titulo">Documentos adicionales (MAX 3MB)</label>
								<input type="file" name="fileElem" id="fileElem" class="form-control" multiple>
								<p style="color: red;" id="errorText"></p>
							</fieldset>
						</div>

						<div class="col-lg-12">
							<fieldset class="form-group">
								<label class="form-label semibold" for="tarea_desc">Descripción</label>
								<div class="summernote-theme-1">
									<textarea id="tarea_desc" name="tarea_desc" class="summernote" name="name"></textarea>
								</div>
							</fieldset>
						</div>
						
						<div class="col-lg-12">
							<button type="submit" name="action" value="add" class="btn btn-rounded btn-inline btn-primary" id="btnGuardar">Guardar</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
    <!-- Contenido -->

    <?php require_once("../MainJs/js.php");?>
    <script type="text/javascript" src="nuevatarea.js"></script>
	<script type="text/javascript" src="../notificacion.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.min.js"></script>
	<script src="js/lib/jquery/jquery.min.js"></script>
	<script src="js/lib/tether/tether.min.js"></script>
	<script src="js/lib/bootstrap/bootstrap.min.js"></script>
	<script src="js/plugins.js"></script>

	<script src="js/lib/jquery-tag-editor/jquery.caret.min.js"></script>
	<script src="js/lib/jquery-tag-editor/jquery.tag-editor.min.js"></script>
	<script src="js/lib/bootstrap-select/bootstrap-select.min.js"></script>
	<script src="js/lib/select2/select2.full.min.js"></script>
</body>
</html>
<?php
	} else {
		header("Location:".Conectar::ruta()."index.php");
	}
?>