<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Biblioteca</title>
    <!-- Link to Bootstrap CSS (assuming it will be in Assets/css) -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/css/bootstrap.min.css">
    <!-- Link to your custom CSS (assuming it will be in Assets/css) -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/css/estilos.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center bg-primary">
                        <h4 class="text-white">Iniciar Sesión</h4>
                    </div>
                    <div class="card-body">
                        <form action="<?php echo base_url; ?>Usuarios/login" method="POST">
                            <div class="mb-3">
                                <label for="usuario" class="form-label">Usuario</label>
                                <input type="text" class="form-control" id="usuario" name="usuario" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Contraseña</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Ingresar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Link to jQuery (assuming it will be in Assets/js) -->
    <script src="<?php echo base_url; ?>Assets/js/jquery-3.6.0.min.js"></script>
    <!-- Link to Bootstrap JS (assuming it will be in Assets/js) -->
    <script src="<?php echo base_url; ?>Assets/js/bootstrap.bundle.min.js"></script>
</body>
</html> 