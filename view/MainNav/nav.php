<?php
/* TODO: Rol 1 es de Usuario */
if ($_SESSION["rol_id"] == 1 || $_SESSION["rol_id"] == 3) {
?>
    <nav class="side-menu">
        <ul class="side-menu-list">
            <li class="blue-dirty">
                <a href="..\Home\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Inicio</span>
                </a>
            </li>

            <li class="blue-dirty">
                <a href="..\NuevoTicket\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Nuevo Ticket</span>
                </a>
            </li>

            <li class="blue-dirty">
                <a href="..\MisTickets\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Mis Tickets</span>
                </a>
            </li>

            <?php if ($_SESSION["rol_id"] == 1) { ?>
                <li class="blue-dirty">
                    <a href="..\ConsultarTicket\">
                        <span class="glyphicon glyphicon-th"></span>
                        <span class="lbl">Todos los Tickets</span>
                    </a>
                </li>
            <?php } ?>
        </ul>
    </nav>
<?php
} else {
?>
    <nav class="side-menu">
        <ul class="side-menu-list">
            <li class="blue-dirty">
                <a href="..\Home\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Inicio</span>
                </a>
            </li>

            <li class="blue-dirty">
                <a href="..\NuevoTicket\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Nuevo Ticket</span>
                </a>
            </li>
            <li class="blue-dirty">
                <a href="..\MisTickets\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Mis Tickets</span>
                </a>
            </li>
            <li class="blue-dirty">
                <a href="..\ConsultarTicket\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Consultar Tickets</span>
                </a>
            </li>
            <li class="blue-dirty">
                <a href="..\TicketsAlmacen\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Tickets Almacen</span>
                </a>
            </li>
            <li class="blue-dirty">
                <a href="..\ConsultarTarea\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Consultar Tareas</span>
                </a>
            </li>
            <li class="blue-dirty">
                <a href="..\MntUsuario\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Usuarios</span>
                </a>
            </li>
            <li class="blue-dirty">
                <a href="..\MntCategoria\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Categorias</span>
                </a>
            </li>

            <li class="blue-dirty">
                <a href="..\MntSubCategoria\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Sub Categorias</span>
                </a>
            </li>
            <li class="blue-dirty">
                <a href="..\MntPrioridad\">
                    <span class="glyphicon glyphicon-th"></span>
                    <span class="lbl">Prioridad</span>
                </a>
            </li>
            <!-- <li class="blue-dirty">
                        <a href="..\MonitorearTicket\">
                            <span class="glyphicon glyphicon-th"></span>
                            <span class="lbl">Monitoreo de Tickets</span>
                        </a>
                    </li>
                    <li class="blue-dirty">
                        <a href="..\NuevaTarea\">
                            <span class="glyphicon glyphicon-th"></span>
                            <span class="lbl">Nueva Tarea</span>
                        </a>
                    </li> -->
        </ul>
    </nav>
<?php
}
?>