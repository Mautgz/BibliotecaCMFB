<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $data['title'] ?? 'Página Principal'; ?> - Biblioteca</title>
    <!-- Link to Bootstrap CSS (assuming it will be in Assets/css) -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/css/bootstrap.min.css">
    <!-- Link to your custom CSS (assuming it will be in Assets/css) -->
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/css/estilos.css">
    <style>
        /* Basic styling for layout */
        body { padding-top: 56px; } /* Adjust for fixed navbar */
        .sidebar { position: fixed; top: 56px; bottom: 0; left: 0; z-index: 100; padding: 10px; box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1); }
        .main-content { margin-left: 220px; padding: 10px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="<?php echo base_url; ?>Home">Biblioteca</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<?php echo base_url; ?>Usuarios/logout">Cerrar Sesión</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="<?php echo base_url; ?>Home">
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<?php echo base_url; ?>Libros">
                                Libros
                            </a>
                        </li>
                        <!-- Ocultando Autor y Materia
                        <li class="nav-item">
                            <a class="nav-link" href="<?php echo base_url; ?>Autor">
                                Autores
                            </a>
                        </li>
                         <li class="nav-item">
                            <a class="nav-link" href="<?php echo base_url; ?>Materias">
                                Materias
                            </a>
                        </li>
                        -->
                        <li class="nav-item">
                            <a class="nav-link" href="<?php echo base_url; ?>Estudiantes">
                                Estudiantes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<?php echo base_url; ?>Prestamos">
                                Préstamos
                            </a>
                        </li>
                         <li class="nav-item">
                            <a class="nav-link" href="<?php echo base_url; ?>Usuarios">
                                Usuarios
                            </a>
                        </li>
                         <li class="nav-item">
                            <a class="nav-link" href="<?php echo base_url; ?>Reportes">
                                Reportes
                            </a>
                        </li>
                         <li class="nav-item">
                            <a class="nav-link" href="<?php echo base_url; ?>Configuracion">
                                Configuración
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <h1><?php echo $data['title'] ?? 'Bienvenido'; ?></h1>
                <p>Contenido de la página principal...</p>
                
                <!-- Tarjetas de totales -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card bg-info text-white">
                            <div class="card-body">
                                <h5 class="card-title">Libros Disponibles</h5>
                                <h2 class="card-text" id="totalLibros">0</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <h5 class="card-title">Préstamos Activos</h5>
                                <h2 class="card-text" id="totalPrestamos">0</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <h5 class="card-title">Préstamos Devueltos</h5>
                                <h2 class="card-text" id="totalDevueltos">0</h2>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Consultas más frecuentes -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Consultas más frecuentes</h5>
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Consulta</th>
                                                <th>Frecuencia</th>
                                                <th>Última consulta</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tablaConsultas">
                                            <!-- Los datos se cargarán dinámicamente -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Gráfico de Préstamos vs Devoluciones -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Préstamos vs Devoluciones</h5>
                                <canvas id="graficoPrestamos" width="400" height="200"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Gráfico de Libros por Materia -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Libros por Materia</h5>
                                <canvas id="graficoMaterias" width="400" height="200"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    // Función para cargar los totales y gráficos
                    function cargarTotales() {
                        // Cargar totales de préstamos
                        fetch(base_url + 'Prestamos/getTotales')
                            .then(response => response.json())
                            .then(data => {
                                document.getElementById('totalPrestamos').textContent = data.prestamos_activos;
                                document.getElementById('totalDevueltos').textContent = data.prestamos_devueltos;
                                // Crear gráfico de préstamos
                                const ctx = document.getElementById('graficoPrestamos').getContext('2d');
                                new Chart(ctx, {
                                    type: 'bar',
                                    data: {
                                        labels: ['Préstamos Activos', 'Préstamos Devueltos'],
                                        datasets: [{
                                            label: 'Cantidad de Préstamos',
                                            data: [data.prestamos_activos, data.prestamos_devueltos],
                                            backgroundColor: [
                                                'rgba(54, 162, 235, 0.5)',
                                                'rgba(75, 192, 192, 0.5)'
                                            ],
                                            borderColor: [
                                                'rgba(54, 162, 235, 1)',
                                                'rgba(75, 192, 192, 1)'
                                            ],
                                            borderWidth: 1
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        scales: {
                                            y: {
                                                beginAtZero: true,
                                                ticks: {
                                                    stepSize: 1
                                                }
                                            }
                                        }
                                    }
                                });
                            })
                            .catch(error => console.error('Error:', error));

                        // Cargar total de libros disponibles
                        fetch(base_url + 'Libros/getTotalDisponibles')
                            .then(response => response.json())
                            .then(data => {
                                document.getElementById('totalLibros').textContent = data.total;
                            })
                            .catch(error => console.error('Error:', error));

                        // Cargar datos de libros por materia
                        fetch(base_url + 'Configuracion/grafico')
                            .then(response => response.json())
                            .then(data => {
                                // Filtrar solo los de tipo materia y eliminar vacíos
                                const materias = data.filter(item => item.tipo === 'materia' && item.nombre && item.nombre.trim() !== '');
                                const labels = materias.map(item => item.nombre);
                                const values = materias.map(item => item.cantidad);
                                const ctxMat = document.getElementById('graficoMaterias').getContext('2d');
                                new Chart(ctxMat, {
                                    type: 'bar',
                                    data: {
                                        labels: labels,
                                        datasets: [{
                                            label: 'Libros por Materia',
                                            data: values,
                                            backgroundColor: 'rgba(220, 53, 69, 0.7)',
                                            borderColor: 'rgba(220, 53, 69, 1)',
                                            borderWidth: 1
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        scales: {
                                            y: {
                                                beginAtZero: true,
                                                ticks: {
                                                    stepSize: 1
                                                }
                                            }
                                        }
                                    }
                                });
                            })
                            .catch(error => console.error('Error:', error));
                    }

                    // Cargar los totales y gráficos al iniciar
                    document.addEventListener('DOMContentLoaded', cargarTotales);

                    // Función para cargar las consultas más frecuentes
                    function cargarConsultasFrecuentes() {
                        fetch(base_url + 'Home/getConsultasFrecuentes')
                            .then(response => response.json())
                            .then(data => {
                                const tablaConsultas = document.getElementById('tablaConsultas');
                                tablaConsultas.innerHTML = '';
                                
                                data.forEach(consulta => {
                                    const row = document.createElement('tr');
                                    row.innerHTML = `
                                        <td>${consulta.consulta}</td>
                                        <td>${consulta.frecuencia}</td>
                                        <td>${consulta.ultima_consulta}</td>
                                    `;
                                    tablaConsultas.appendChild(row);
                                });
                            })
                            .catch(error => console.error('Error:', error));
                    }

                    // Cargar las consultas frecuentes al iniciar
                    document.addEventListener('DOMContentLoaded', cargarConsultasFrecuentes);
                </script>
            </main>
        </div>
    </div>

    <!-- Link to jQuery (assuming it will be in Assets/js) -->
    <script src="<?php echo base_url; ?>Assets/js/jquery-3.6.0.min.js"></script>
    <!-- Link to Bootstrap JS (assuming it will be in Assets/js) -->
    <script src="<?php echo base_url; ?>Assets/js/bootstrap.bundle.min.js"></script>
</body>
</html> 