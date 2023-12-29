<?php
  require_once("../../config/conexion.php"); 
  if(isset($_SESSION["usu_id"])){ 
?>
<!DOCTYPE html>
<html>
<head>
    <?php require_once("../MainHead/head.php");?>
	<title>Consultar Tareas</title>
</head>
<body class="with-side-menu">

    <?php require_once("../MainHeader/header.php");?>

    <div class="mobile-menu-left-overlay"></div>
    
    <?php require_once("../MainNav/nav.php");?>
	
	<!-- Contenido -->
	<div class="page-content" id="recarga">
		<div class="container-fluid">

			<header class="section-header">
				<div class="tbl">
					<div class="tbl-row">
						<div class="tbl-cell">
							<h3>Consultar Tareas</h3>
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="../Home/">Inicio</a></li>
								<li class="active">Consultar Tareas</li>
							</ol>
						</div>
					</div>
				</div>
			</header>

			<div class="box-typical box-typical-padding">
				<div class="box-typical box-typical-padding" id="table">
					<table id="tarea_data" class="table table-bordered table-striped table-vcenter js-dataTable-full">
						<thead>
							<tr>
								<th style="width: 5%;">#Tarea</th>
								<th style="width: 5%;">#Ticket</th>
								<th style="width: 5%;">Creador de tarea</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">Fecha de creación</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">Título</th>
								<th class="d-none d-sm-table-cell" style="width: 30%;">Descripcion</th>
								<th class="d-none d-sm-table-cell" style="width: 25%;">Estado</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">Tiempo de finalización</th>
								<th class="d-none d-sm-table-cell" style="width: 20%;">Fecha Finalización</th>
								<th class="d-none d-sm-table-cell" style="width: 5%;">Detalle</th>
							</tr>
						</thead>
						<tbody>

						</tbody>
					</table>
				</div>
			</div>

		</div>
	</div>
	<!-- Contenido -->
	<?php require_once("modalasignar.php");?>

	<?php require_once("../MainJs/js.php");?>

	<script type="text/javascript" src="consultartarea.js"></script>

	<script type="text/javascript" src="../notificacion.js"></script>

</body>
</html>
<?php
  } else {
    header("Location:".Conectar::ruta()."index.php");
  }
?>