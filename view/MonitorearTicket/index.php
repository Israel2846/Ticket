<?php
  require_once("../../config/conexion.php"); 
  if(isset($_SESSION["usu_id"])){ 
?>
<!DOCTYPE html>
<html>
    <?php require_once("../MainHead/head.php");?>
	<title>AnderCode</>::Consultar Ticket</title>
</head>
<body class="with-side-menu">

    <?php require_once("../MainHeader/header.php");?>

    <div class="mobile-menu-left-overlay"></div>
    
    <?php require_once("../MainNav/nav.php");?>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>

	<!-- Contenido -->
	<div class="page-content" id="recarga">
		<div class="container-fluid">

		<header class="section-header">
				<div class="tbl">
					<div class="tbl-row">
						<div class="tbl-cell">
							<h3>Monitoreo de Tickets en Tiempo Real</h3>
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="#">Home</a></li>
								<li class="active">Monitoreo de Tickets</li>
							</ol>
						</div>
					</div>
				</div>
			</header>

			<div class="box-typical box-typical-padding">
				
				<div class="row" id="viewuser">
					<div class="col-lg-3">
						<fieldset class="form-group">
							<label class="form-label" for="tick_titulo">Titulo</label>
							<input type="text" class="form-control" id="tick_titulo" name="tick_titulo" placeholder="Ingrese Titulo" required>
						</fieldset>
					</div>

					<div class="col-lg-3">
						<fieldset class="form-group">
							<label class="form-label" for="cat_id">Categoria</label>
							<select class="select2" id="cat_id" name="cat_id" data-placeholder="Seleccionar">
								<option label="Seleccionar"></option>

							</select>
						</fieldset>
					</div>

					<div class="col-lg-2">
						<fieldset class="form-group">
							<label class="form-label" for="prio_id">Prioridad</label>
							<select class="select2" id="prio_id" name="prio_id" data-placeholder="Seleccionar">
								<option label="Seleccionar"></option>

							</select>
						</fieldset>
					</div>

					<div class="col-lg-2">
						<fieldset class="form-group">
							<label class="form-label" for="btnfiltrar">&nbsp;</label>
							<button type="submit" class="btn btn-rounded btn-primary btn-block" id="btnfiltrar">Filtrar</button>
						</fieldset>
					</div>

					<div class="col-lg-2">
						<fieldset class="form-group">
							<label class="form-label" for="btntodo">&nbsp;</label>
							<button class="btn btn-rounded btn-primary btn-block" id="btntodo">Ver Todo</button>
						</fieldset>
					</div>
				</div>

				<div class="box-typical box-typical-padding" id="table">
					<table id="ticket_data" class="table table-bordered table-striped table-vcenter js-dataTable-full">
						<thead>
							<tr>
								<th style="width: 5%;">#Ticket</th>
								<th style="width: 15%;">Categoria</th>
								<th class="d-none d-sm-table-cell" style="width: 30%;">Titulo</th>
								<th class="d-none d-sm-table-cell" style="width: 5%;">Prioridad</th>
								<th class="d-none d-sm-table-cell" style="width: 5%;">Estado</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">Fecha Creación</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">Fecha Asignación</th>
								<th class="d-none d-sm-table-cell" style="width: 5%;">T. Respuesta</th>
								<th class="d-none d-sm-table-cell" style="width: 5%;">T. Transcurrido</th>
								<th class="d-none d-sm-table-cell" style="width: 5%;">T. Tarea</th>
								<th class="d-none d-sm-table-cell" style="width: 5%;">T. Total</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">Fecha Cierre</th>
								<th class="d-none d-sm-table-cell" style="width: 10%;">Soporte</th>
								<th class="text-center" style="width: 5%;"></th>
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

	<script type="text/javascript" src="monitorearticket.js"></script>

	<script type="text/javascript" src="../notificacion.js"></script>

	<script>
    let segundos_recarga = 90;
    let miFecha = new Date();
    let dato_url = miFecha.getYear().toString() + miFecha.getMonth().toString() + miFecha.getDate().toString() + miFecha.getHours().toString() + miFecha.getMinutes().toString() + miFecha.getSeconds().toString();
    setTimeout( function() {
      window.location = `index.php?parametro=${dato_url}`;
    }, segundos_recarga * 1000);
  	</script>
	<script>
		$(document).ready(function(){
			$().DataTable({
				"paging": false
			})
		});
	</script>

</body>
</html>
<?php
  } else {
    header("Location:".Conectar::ruta()."index.php");
  }
?>