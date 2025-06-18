<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CMFB Biblioteca</title>
    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/css/adminlte.min.css">
    <!-- DataTables -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/plugins/datatables-buttons/css/buttons.bootstrap4.min.css">
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css">
    <!-- Toastr -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/plugins/toastr/toastr.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/css/custom.css">
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
    <!-- Navbar -->
    <nav class="main-header navbar navbar-expand navbar-white navbar-light">
        <!-- Left navbar links -->
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
            </li>
        </ul>
        <!-- Right navbar links -->
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="<?php echo base_url; ?>Logout">
                    <i class="fa fa-sign-out-alt"></i> Cerrar Sesión
                </a>
            </li>
        </ul>
    </nav>
    <!-- /.navbar -->

    <!-- Main Sidebar Container -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <!-- Brand Logo -->
        <a href="<?php echo base_url; ?>" class="brand-link">
            <img src="<?php echo base_url; ?>Assets/img/logo.png" alt="Logo" class="brand-image img-circle elevation-3" style="opacity: .8">
            <span class="brand-text font-weight-light">CMFB Biblioteca</span>
        </a>

        <!-- Sidebar -->
        <div class="sidebar">
            <!-- Sidebar Menu -->
            <nav class="mt-2">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                    <li class="nav-item">
                        <a href="<?php echo base_url; ?>" class="nav-link">
                            <i class="nav-icon fa fa-home"></i>
                            <p>Inicio</p>
                        </a>
                    </li>
                    <?php if ($_SESSION['rol'] == 1) { ?>
                    <li class="nav-item">
                        <a href="<?php echo base_url; ?>Usuarios" class="nav-link">
                            <i class="nav-icon fa fa-users"></i>
                            <p>Usuarios</p>
                        </a>
                    </li>
                    <?php } ?>
                    <li class="nav-item">
                        <a href="<?php echo base_url; ?>Libros" class="nav-link">
                            <i class="nav-icon fa fa-book"></i>
                            <p>Libros</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="<?php echo base_url; ?>Prestamos" class="nav-link">
                            <i class="nav-icon fa fa-hand-holding"></i>
                            <p>Préstamos</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="<?php echo base_url; ?>Configuracion" class="nav-link">
                            <i class="nav-icon fa fa-cog"></i>
                            <p>Configuración</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="<?php echo base_url; ?>Carousel" class="nav-link">
                            <i class="nav-icon fa fa-images"></i>
                            <p>Gestionar Carousel</p>
                        </a>
                    </li>
                </ul>
            </nav>
            <!-- /.sidebar-menu -->
        </div>
        <!-- /.sidebar -->
    </aside>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0"><?php echo $data['titulo']; ?></h1>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.content-header -->

        <!-- Main content -->
        <div class="content">
            <div class="container-fluid">
                <?php require_once 'Views/partials/chatbot.php'; ?>
            </div>
        </div>
    </div>
    <!-- /.content-wrapper -->
    <footer class="main-footer"> 