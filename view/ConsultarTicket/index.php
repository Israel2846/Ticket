<?php
  require_once("../../config/conexion.php"); 
//   if(isset($_SESSION["usu_id"])){ 
?>
<!DOCTYPE html>
<html>
    <?php require_once("../MainHead/head.php");?>
	<title>Consultar Tickets</title>
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
							<h3>Consultar Tickets</h3>
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="../Home/">Inicio</a></li>
								<li class="active">Consultar Tickets</li>
							</ol>
						</div>
					</div>
				</div>
			</header>

			<div class="box-typical box-typical-padding">
				<div class="row">
					<div class="col-lg-12" id="tabla_tickets_abiertos">
						<fieldset class="form-group">
							<label class="form-label semibold"><h3>Tickets Abiertos</h3></label>
							<table id="ticket_abierto" class="table table-bordered table-striped table-vcenter js-dataTable-full">
								<thead>
									<tr>
										<th style="width: 5%;">#Ticket</th>
										<th style="width: 10%;">Categoria</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Titulo</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">Prioridad</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">Estado</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">F. Creación</th>
										<!-- <th class="d-none d-sm-table-cell" style="width: 10%;">F. Asignación</th> -->
										<!-- <th class="d-none d-sm-table-cell" style="width: 5%;">T. Respuesta</th> -->
										<th class="d-none d-sm-table-cell" style="width: 5%;">T. Transcurrido</th>
										<!-- <th class="d-none d-sm-table-cell" style="width: 5%;">T. Total</th> -->
										<!-- <th class="d-none d-sm-table-cell" style="width: 10%;">F. Cierre</th> -->
										<th class="d-none d-sm-table-cell" style="width: 10%;">Creador</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Almacén</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Área</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Soporte</th>
										<th class="text-center" style="width: 5%;">Info</th>
									</tr>
								</thead>
								<tbody>

								</tbody>
							</table>
						</fieldset>
					</div>

					<div class="col-lg-12" id="tabla_tickets_en_proceso">
						<fieldset class="form-group">
							<label class="form-label semibold"><h3>Tickets En proceso</h3></label>
							<table id="ticket_en_proceso" class="table table-bordered table-striped table-vcenter js-dataTable-full">
								<thead>
									<tr>
										<th style="width: 5%;">#Ticket</th>
										<th style="width: 10%;">Categoria</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Titulo</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">Prioridad</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">Estado</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">F. Creación</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">F. Asignación</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">T. Respuesta</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">T. Transcurrido</th>
										<!-- <th class="d-none d-sm-table-cell" style="width: 5%;">T. Total</th> -->
										<!-- <th class="d-none d-sm-table-cell" style="width: 10%;">F. Cierre</th> -->
										<th class="d-none d-sm-table-cell" style="width: 10%;">Creador</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Soporte</th>
										<th class="text-center" style="width: 5%;">Info</th>
									</tr>
								</thead>
								<tbody>

								</tbody>
							</table>
						</fieldset>
					</div>

					<div class="col-lg-12" id="tabla_tickets_pausados">
						<fieldset class="form-group">
							<label class="form-label semibold"><h3>Tickets Pausados</h3></label>
							<table id="ticket_pausado" class="table table-bordered table-striped table-vcenter js-dataTable-full">
								<thead>
									<tr>
										<th style="width: 5%;">#Ticket</th>
										<th style="width: 10%;">Categoria</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Titulo</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">Prioridad</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">Estado</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">F. Creación</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">F. Asignación</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">T. Respuesta</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">T. Transcurrido</th>
										<!-- <th class="d-none d-sm-table-cell" style="width: 5%;">T. Total</th> -->
										<!-- <th class="d-none d-sm-table-cell" style="width: 10%;">F. Cierre</th> -->
										<th class="d-none d-sm-table-cell" style="width: 10%;">Creador</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Soporte</th>
										<th class="text-center" style="width: 5%;">Info</th>
									</tr>
								</thead>
								<tbody>

								</tbody>
							</table>
						</fieldset>
					</div>

					<div class="col-lg-12" id="tabla_tickets_cerrados">
						<fieldset class="form-group">
							<label class="form-label semibold"><h3>Tickets Cerrados</h3></label>
							<table id="ticket_cerrado" class="table table-bordered table-striped table-vcenter js-dataTable-full">
								<thead>
									<tr>
										<th style="width: 5%;">#Ticket</th>
										<th style="width: 10%;">Categoria</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Titulo</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">Prioridad</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">Estado</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">F. Creación</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">F. Asignación</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">T. Respuesta</th>
										<th class="d-none d-sm-table-cell" style="width: 5%;">T. Total</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">F. Cierre</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Creador</th>
										<th class="d-none d-sm-table-cell" style="width: 10%;">Soporte</th>
										<th class="text-center" style="width: 5%;">Info</th>
									</tr>
								</thead>
								<tbody>

								</tbody>
							</table>
						</fieldset>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Contenido -->
	<?php require_once("modalasignar.php");?>

	<?php require_once("../MainJs/js.php");?>

	<script type="text/javascript" src="consultarticket.js"></script>

	<script type="text/javascript" src="../notificacion.js"></script>

</body>
</html>
<?php
  /* } else {
    header("Location:".Conectar::ruta()."index.php");
  } */
?>