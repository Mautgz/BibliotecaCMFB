<?php include "Views/Templates/header.php"; ?>
<div class="app-title">
    <div>
        <h1><i class="fa fa-dashboard"></i> Panel de Administración</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-6 col-lg-3">
        <div class="widget-small primary coloured-icon"><i class="icon fa fa-users fa-3x"></i>
            <a class="info" href="<?php echo base_url; ?>Usuarios">
                <h4 style="color:black">Usuarios</h4>
                <p><b style="color:black"><?php echo $data['usuarios']['total'] ?></b></p>
            </a>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="widget-small info coloured-icon"><i class="icon fa fa-book fa-3x"></i>
            <a class="info" href="<?php echo base_url; ?>Libros">
                <h4 style="color:black">Libros</h4>
                <p><b style="color:black"><?php echo $data['libros']['total'] ?></b></p>
            </a>
        </div>
    </div>
   
    <!-- <div class="col-md-6 col-lg-3">
        <div class="widget-small danger coloured-icon"><i class="icon fa fa-tags fa-3x"></i>
            <a class="info" href="<?php echo base_url; ?>Editorial">
                <h4>Editorial</h4>
                <p><b><?php echo $data['editorial']['total'] ?></b></p>
            </a>
        </div>
    </div> -->
    <div class="col-md-6 col-lg-3">
        <div class="widget-small warning coloured-icon"><i class="icon fa fa-graduation-cap fa-3x"></i>
            <a class="info" href="<?php echo base_url; ?>Estudiantes">
                <h4 style="color:black" >Estudiantes</h4>
                <p><b style="color:black"><?php echo $data['estudiantes']['total'] ?></b></p>
            </a>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="widget-small danger coloured-icon"><i class="icon fa fa-hourglass-start fa-3x"></i>
            <a class="info" href="<?php echo base_url; ?>Prestamos">
                <h4 style="color:black">Prestamos</h4>
                <p><b style="color:black"><?php echo $data['prestamos']['total'] ?></b></p>
            </a>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="widget-small primary coloured-icon"><i class="icon fa fa-cogs fa-3x"></i>
            <a class="info" href="<?php echo base_url; ?>Configuracion">
                <h6 style="color:black">Configuracion</h6>
            </a>
        </div>
    </div>

</div>
<!-- <div class="row">
    <div class="col-md-12">
        <div class="tile">
            <h3 class="tile-title">Libros Disponibles</h3>
            <div class="embed-responsive embed-responsive-16by9">
                <canvas class="embed-responsive-item" id="reportePrestamo"></canvas>
            </div>
        </div>
    </div>
</div> -->

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

<!-- Gráficas en dos columnas -->
<div class="row">
    <div class="col-md-6">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Préstamos vs Devoluciones</h5>
                <canvas id="graficoPrestamos" width="400" height="200"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-6">
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
</script>

<!-- Sección de Consultas Frecuentes -->
<div class="row mt-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Consultas más Frecuentes del Chatbot</h5>
                <div class="table-responsive">
                    <table id="consultas-table" class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Consulta</th>
                                <th>Frecuencia</th>
                                <th>Última Consulta</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Función para cargar las consultas frecuentes
function cargarConsultasFrecuentes() {
    fetch(base_url + 'Configuracion/getConsultasFrecuentes')
        .then(res => res.json())
        .then(consultas => {
            const tbody = document.querySelector('#consultas-table tbody');
            tbody.innerHTML = '';
            consultas.forEach(consulta => {
                const fecha = new Date(consulta.ultima_consulta).toLocaleString();
                tbody.innerHTML += `
                    <tr>
                        <td>${consulta.consulta}</td>
                        <td>${consulta.frecuencia}</td>
                        <td>${fecha}</td>
                    </tr>
                `;
            });
        });
}

// Cargar las consultas frecuentes al iniciar
document.addEventListener('DOMContentLoaded', cargarConsultasFrecuentes);
</script>

<?php include "Views/Templates/footer.php"; ?>