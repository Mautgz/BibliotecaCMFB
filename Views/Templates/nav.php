<?php
$id_user = $_SESSION['id_usuario'];
?>
<div class="app-sidebar">
    <div class="app-sidebar-header">
        <div class="app-sidebar-logo">
            <img src="<?php echo base_url; ?>Assets/img/logo.png" alt="Logo" class="logo-icon">
            <span class="logo-text">Biblioteca</span>
        </div>
        <div class="app-sidebar-mobile-back">
            <button class="btn btn-icon btn-link">
                <i class="fas fa-arrow-left"></i>
            </button>
        </div>
    </div>
    <div class="app-sidebar-content">
        <div class="app-sidebar-menu">
            <ul class="menu">
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Configuracion/admin" class="menu-link">
                        <i class="fas fa-home"></i>
                        <span class="menu-text">Inicio</span>
                    </a>
                </li>
                <?php if (isset($data['perm_config']) || $id_user == 1) { ?>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Libros" class="menu-link">
                        <i class="fas fa-book"></i>
                        <span class="menu-text">Libros</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Autor" class="menu-link">
                        <i class="fas fa-user-edit"></i>
                        <span class="menu-text">Autor</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Editorial" class="menu-link">
                        <i class="fas fa-building"></i>
                        <span class="menu-text">Editorial</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Estudiantes" class="menu-link">
                        <i class="fas fa-users"></i>
                        <span class="menu-text">Estudiantes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Materias" class="menu-link">
                        <i class="fas fa-bookmark"></i>
                        <span class="menu-text">Materias</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Prestamos" class="menu-link">
                        <i class="fas fa-hand-holding"></i>
                        <span class="menu-text">Préstamos</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Carousel" class="menu-link">
                        <i class="fas fa-images"></i>
                        <span class="menu-text">Carousel</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Reportes" class="menu-link">
                        <i class="fas fa-chart-bar"></i>
                        <span class="menu-text">Reportes</span>
                    </a>
                </li>
                <?php } ?>
                <?php if ($id_user == 1) { ?>
                <li class="menu-item">
                    <a href="<?php echo base_url; ?>Usuarios" class="menu-link">
                        <i class="fas fa-users-cog"></i>
                        <span class="menu-text">Usuarios</span>
                    </a>
                </li>
                <?php } ?>
            </ul>
        </div>
    </div>
</div> 