<?php
  require_once("../../config/conexion.php"); 
  if(isset($_SESSION["usu_id"])){ 
?>
<!DOCTYPE html>
<html>
    <?php require_once("../MainHead/head.php");?>
	<title>AnderCode</>::Mis Ticket</title>
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
							<h3>Mis Tickets</h3>
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="#">Home</a></li>
								<li class="active">Mis Tickets</li>
							</ol>
						</div>
					</div>
				</div>
			</header>

			<div class="col-lg-12" id="misTickets">
                <fieldset class="form-group">
					<table id="mis_tickets" class="table table-bordered table-striped table-vcenter js-dataTable-full">
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
								<th class="d-none d-sm-table-cell" style="width: 5%;">T. Total</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">F. Cierre</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">Creador</th>
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
	<!-- Contenido -->
	<?php require_once("../MainJs/js.php");?>

	<script type="text/javascript" src="mistickets.js"></script>

	<script type="text/javascript" src="../notificacion.js"></script>

</body>
</html>
<?php
  } else {
    header("Location:".Conectar::ruta()."index.php");
  }
?>