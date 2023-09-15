<div id="modalmantenimiento" class="modal fade bd-example-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="modal-close" data-dismiss="modal" aria-label="Close">
                    <i class="font-icon-close-2"></i>
                </button>
                <h4 class="modal-title" id="mdltitulo"></h4>
            </div>
            <form method="post" id="usuario_form">
                <div class="modal-body">
                    <input type="hidden" id="usu_id" name="usu_id">

                    <div class="form-group">
                        <label class="form-label" for="usu_nom">Nombre</label>
                        <input type="text" class="form-control" id="usu_nom" name="usu_nom" placeholder="Ingrese Nombre" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="usu_ape">Apellido</label>
                        <input type="text" class="form-control" id="usu_ape" name="usu_ape" placeholder="Ingrese Apellido" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="usu_correo">Correo Electronico</label>
                        <input type="email" class="form-control" id="usu_correo" name="usu_correo" placeholder="test@test.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="usu_pass">Contraseña</label>
                        <input type="text" class="form-control" id="usu_pass" name="usu_pass" placeholder="************" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="usu_almacen">Almacen</label>
                        <select class="select2" id="usu_almacen" name="usu_almacen">
                            
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="usu_area">Area</label>
                        <select class="select2" id="usu_area" name="usu_area">
                            
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="rol_id">Rol</label>
                        <select class="select2" id="rol_id" name="rol_id">
                            <option value="1">Soporte</option>
                            <option value="2">Admin</option>
                            <option value="3">Usuario</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="usu_telf">Telefono</label>
                        <input type="text" class="form-control" id="usu_telf" name="usu_telf" placeholder="Ingrese Telefono" required>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-rounded btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="submit" name="action" id="#" value="add" class="btn btn-rounded btn-primary">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>