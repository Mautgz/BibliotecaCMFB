<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo Público de Libros</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 4.5.3 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css">
    <!-- Main CSS-->
    <link href="<?php echo $data['base_url']; ?>Assets/css/main.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="<?php echo $data['base_url']; ?>Assets/css/font-awesome.min.css">
    <style>
        
        body {
            background: #f4f6fa;
        }
        .uni-header {
            background: #002147;
            color: #fff;
            padding: 30px 0 20px 0;
            margin-bottom: 0;
        }
        .uni-header__logo {
            font-size: 2.2rem;
            font-weight: 700;
            letter-spacing: 2px;
            color: #fff;
            text-decoration: none;
        }
        .uni-header__subtitle {
            font-size: 1.1rem;
            color: #b0c4de;
            margin-top: 5px;
        }
        .announcements {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            padding: 25px 30px;
            margin-bottom: 30px;
        }
        .announcements h4 {
            color: #002147;
            font-weight: 600;
            margin-bottom: 18px;
        }
        .announcement-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .announcement-item:last-child {
            margin-bottom: 0;
        }
        .announcement-icon {
            font-size: 1.7rem;
            color: #007bff;
            margin-right: 15px;
        }
        .announcement-content {
            font-size: 1rem;
            color: #333;
        }
        .banner-placeholder {
            background: #e9ecef;
            border-radius: 8px;
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #888;
            font-size: 1.3rem;
            margin-bottom: 30px;
            font-style: italic;
        }
        .search-filters {
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        .book-card {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            min-height: 210px;
        }
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.12);
        }
        .book-title {
            color: #002147;
            font-size: 18px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .book-info {
            color: #555;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .book-info i {
            width: 20px;
            color: #007bff;
        }
        .pagination {
            margin-top: 30px;
        }
        .pagination .page-link {
            color: #007bff;
        }
        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
        }
        
        /* Estilos para paginación responsive */
        .pagination-container {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            margin: 0 -15px;
            padding: 0 15px;
        }
        
        .pagination {
            flex-wrap: nowrap;
            min-width: max-content;
            margin: 0;
        }
        
        .pagination .page-item {
            margin: 0 2px;
        }
        
        .pagination .page-link {
            min-width: 40px;
            text-align: center;
            padding: 8px 12px;
            border-radius: 4px;
            white-space: nowrap;
        }
        
        @media (max-width: 768px) {
            .pagination .page-link {
                padding: 6px 8px;
                font-size: 14px;
                min-width: 35px;
            }
            
            .pagination .page-item {
                margin: 0 1px;
            }
        }
        
        @media (max-width: 576px) {
            .pagination .page-link {
                padding: 5px 6px;
                font-size: 12px;
                min-width: 30px;
            }
        }
        .no-results {
            text-align: center;
            padding: 40px;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.08);
        }
        .no-results i {
            font-size: 48px;
            color: #007bff;
            margin-bottom: 15px;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        @media (max-width: 767px) {
            .announcements, .banner-placeholder {
                padding: 15px 10px;
            }
        }

        /* Chatbot styles */
        .chatbot-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .chatbot-icon {
            width: 60px;
            height: 60px;
            background: #007bff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .chatbot-icon:hover {
            transform: scale(1.1);
            background: #0056b3;
        }

        .chatbot-icon i {
            color: white;
            font-size: 24px;
        }

        .chatbot-window {
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 350px;
            height: 500px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            display: none;
            flex-direction: column;
            overflow: hidden;
        }

        .chatbot-window.active {
            display: flex;
        }

        .chatbot-header {
            background: #007bff;
            color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .chatbot-header h5 {
            margin: 0;
            font-size: 16px;
        }

        .chatbot-body {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8f9fa;
        }

        .chat-messages {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
            max-height: 300px;
            overflow-y: auto;
            padding-right: 10px;
            position: relative;
        }

        .scroll-down-btn {
            display: none;
            position: absolute;
            right: 10px;
            bottom: 10px;
            z-index: 10;
            background: #007bff;
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            cursor: pointer;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .chat-messages.has-overflow .scroll-down-btn {
            display: flex;
        }

        .message {
            margin-bottom: 10px;
            max-width: 80%;
        }

        .message-content {
            padding: 10px 15px;
            border-radius: 15px;
            background: white;
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }

        .user-message {
            margin-left: auto;
        }

        .user-message .message-content {
            background: #007bff;
            color: white;
        }

        .bot-message {
            margin-right: auto;
        }

        .chat-input {
            padding: 15px;
            background: white;
            border-top: 1px solid #eee;
        }

        .chat-input form {
            display: flex;
            gap: 10px;
        }

        .chat-input input {
            flex: 1;
            border: 1px solid #ddd;
            border-radius: 20px;
            padding: 8px 15px;
        }

        .chat-input button {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .loader {
            width: 20px;
            height: 20px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #007bff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            display: inline-block;
            margin-right: 5px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .book-suggestion {
            background: white;
            padding: 10px;
            border-radius: 5px;
            margin-top: 5px;
            border: 1px solid #eee;
        }

        .book-suggestion h6 {
            margin: 0 0 5px 0;
            color: #007bff;
        }

        .book-suggestion p {
            margin: 0;
            font-size: 12px;
            color: #666;
        }

        /* Carousel styles */
        .carousel {
            margin-bottom: 30px;
        }

        .carousel-content {
            height: 400px;
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            text-align: center;
        }

        .carousel-caption {
            background: rgba(0, 0, 0, 0.6);
            padding: 30px;
            border-radius: 10px;
            max-width: 600px;
            margin: 0 auto;
        }

        .carousel-caption h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            color: #fff;
        }

        .carousel-caption p {
            font-size: 1.2rem;
            margin-bottom: 20px;
            color: #fff;
        }

        .carousel-caption .btn {
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 30px;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }

        .carousel-caption .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .carousel-indicators {
            margin-bottom: 1rem;
        }

        .carousel-indicators button {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin: 0 5px;
        }

        .carousel-control-prev,
        .carousel-control-next {
            width: 5%;
            opacity: 0.8;
        }

        @media (max-width: 768px) {
            .carousel-content {
                height: 300px;
            }

            .carousel-caption h2 {
                font-size: 1.8rem;
            }

            .carousel-caption p {
                font-size: 1rem;
            }

            .carousel-caption .btn {
                padding: 8px 20px;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body class="app">
    <?php require_once __DIR__ . '/../partials/public_header.php'; ?>
    <!-- Header estilo universitario -->
    <header class="uni-header">
        <div class="container">
            <h1>Bienvenidos a la Biblioteca virtual del CMFB</h1>
            <div class="uni-header__subtitle">Catálogo público de libros</div>
        </div>
    </header>

    <!-- Carousel -->
    <div class="container-fluid px-0">
        <div id="mainCarousel" class="carousel slide" data-ride="carousel" data-interval="5000">
        <div class="carousel-indicators" id="carouselIndicators"></div>
        <div class="carousel-inner" id="carouselItems"></div>
            <a class="carousel-control-prev" href="#mainCarousel" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon"></span>
                <span class="sr-only">Anterior</span>
            </a>
            <a class="carousel-control-next" href="#mainCarousel" role="button" data-slide="next">
            <span class="carousel-control-next-icon"></span>
                <span class="sr-only">Siguiente</span>
            </a>
        </div>
    </div>

    <!-- Modal para imagen expandida -->
    <div class="modal fade" id="carouselImageModal" tabindex="-1" aria-labelledby="carouselImageModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content bg-transparent border-0">
          <div class="modal-body text-center p-0">
            <img id="expandedCarouselImage" src="" alt="Imagen expandida" style="max-width:100%; max-height:80vh; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.3);">
          </div>
        </div>
      </div>
    </div>

    <main class="app-content" style="padding-bottom: 100px;margin-left:0">
        <div class="container">
            <!-- Áreas temáticas Dewey -->
            <div class="row mb-4 justify-content-center">
                <?php
                $areas_dewey = [
                    '0' => 'Generalidades',
                    '1' => 'Filosofía y Psicología',
                    '2' => 'Religión',
                    '3' => 'Ciencias Sociales',
                    '4' => 'Lenguas',
                    '5' => 'Ciencias Naturales y Matemáticas',
                    '6' => 'Tecnología',
                    '7' => 'Artes y Recreación',
                    '8' => 'Literatura',
                    '9' => 'Historia y Geografía'
                ];
                $current_dewey = $_GET['dewey'] ?? '';
                ?>
                <?php foreach ($areas_dewey as $num => $nombre): ?>
                    <div class="col-6 col-md-3 col-lg-2 mb-2">
                        <a href="?dewey=<?php echo $num; ?><?php echo !empty($_GET['title']) ? '&title='.urlencode($_GET['title']) : ''; ?><?php echo !empty($_GET['author']) ? '&author='.urlencode($_GET['author']) : ''; ?>" class="btn btn-block <?php echo ($current_dewey === $num ? 'btn-primary' : 'btn-outline-primary'); ?>" style="font-weight:500; border-radius:12px; padding:18px 8px; white-space:normal; min-height:80px;">
                            <span style="font-size:1.1em;"><i class="fa fa-folder-open mr-1"></i> <?php echo $nombre; ?></span>
                        </a>
                    </div>
                <?php endforeach; ?>
            </div>

           <!--  <!-- Banner/placeholder de eventos o avisos --
            <div class="banner-placeholder mb-4">
                [Espacio para banner de eventos, campañas o imágenes institucionales]
            </div> -->

            <!-- Anuncios destacados -->
            <div class="announcements mb-4">
                <h4><i class="fa fa-bullhorn announcement-icon"></i> Anuncios</h4>
                <div class="announcement-item">
                    <span class="announcement-icon"><i class="fa fa-calendar"></i></span>
                    <div class="announcement-content">Semana del Libro: Participa en nuestras actividades del 23 al 27 de abril.</div>
                </div>
                <div class="announcement-item">
                    <span class="announcement-icon"><i class="fa fa-info-circle"></i></span>
                    <div class="announcement-content">Recuerda renovar tus préstamos a tiempo para evitar recargos.</div>
                </div>
                <div class="announcement-item">
                    <span class="announcement-icon"><i class="fa fa-users"></i></span>
                    <div class="announcement-content">Consulta nuestros talleres de formación en investigación y uso de recursos digitales.</div>
                </div>
            </div>

            <!-- Filtros de búsqueda -->
            <div class="search-filters">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <input type="text" class="form-control" name="title" id="searchTitle" placeholder="Buscar por título..." value="<?php echo htmlspecialchars($data['filters']['title'] ?? ''); ?>">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <input type="text" class="form-control" name="author" id="searchAuthor" placeholder="Buscar por autor..." value="<?php echo htmlspecialchars($data['filters']['author'] ?? ''); ?>">
                        </div>
                    </div>
                    <input type="hidden" name="dewey" id="searchDewey" value="<?php echo htmlspecialchars($data['filters']['dewey'] ?? ''); ?>">
                    </div>
            </div>

            <!-- Lista de libros -->
            <div class="row" id="libros-container">
                <?php if (!empty($data['libros'])): ?>
                    <?php foreach ($data['libros'] as $libro): ?>
                        <div class="col-md-3 mb-4">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><?php echo htmlspecialchars($libro['titulo'] ?? ''); ?></h5>
                                    <p class="card-text">
                                        <strong>Autor:</strong> <?php echo htmlspecialchars($libro['autor_personal'] ?? ''); ?><br>
                                        <strong>Clasificación:</strong> <?php echo htmlspecialchars($libro['codigo_dewey'] ?? ''); ?>
                                    </p>
                                    <button type="button" 
                                            class="btn btn-primary btn-sm" 
                                            data-toggle="modal" 
                                            data-target="#detalleModal<?php echo $libro['id']; ?>">
                                        Ver detalles
                                    </button>
                                </div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <div class="col-12">
                        <div class="alert alert-info">
                            No se encontraron libros que coincidan con los criterios de búsqueda.
                        </div>
                    </div>
                <?php endif; ?>
            </div>

            <!-- Paginación -->
            <?php if ($data['total_pages'] > 1): ?>
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="pagination-container">
                            <nav aria-label="Navegación de páginas">
                                <ul class="pagination justify-content-center">
                                    <?php if ($data['current_page'] > 1): ?>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=<?php echo $data['current_page'] - 1; ?><?php echo !empty($data['filters']['title']) ? '&title=' . urlencode($data['filters']['title']) : ''; ?><?php echo !empty($data['filters']['author']) ? '&author=' . urlencode($data['filters']['author']) : ''; ?><?php echo !empty($data['filters']['dewey']) ? '&dewey=' . urlencode($data['filters']['dewey']) : ''; ?>">
                                                Anterior
                                            </a>
                                        </li>
                                    <?php endif; ?>
                                    
                                    <?php for ($i = 1; $i <= $data['total_pages']; $i++): ?>
                                        <li class="page-item <?php echo $i === $data['current_page'] ? 'active' : ''; ?>">
                                            <a class="page-link" href="?page=<?php echo $i; ?><?php echo !empty($data['filters']['title']) ? '&title=' . urlencode($data['filters']['title']) : ''; ?><?php echo !empty($data['filters']['author']) ? '&author=' . urlencode($data['filters']['author']) : ''; ?><?php echo !empty($data['filters']['dewey']) ? '&dewey=' . urlencode($data['filters']['dewey']) : ''; ?>">
                                                <?php echo $i; ?>
                                            </a>
                                        </li>
                                    <?php endfor; ?>
                                    
                                    <?php if ($data['current_page'] < $data['total_pages']): ?>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=<?php echo $data['current_page'] + 1; ?><?php echo !empty($data['filters']['title']) ? '&title=' . urlencode($data['filters']['title']) : ''; ?><?php echo !empty($data['filters']['author']) ? '&author=' . urlencode($data['filters']['author']) : ''; ?><?php echo !empty($data['filters']['dewey']) ? '&dewey=' . urlencode($data['filters']['dewey']) : ''; ?>">
                                                Siguiente
                                            </a>
                                        </li>
                                    <?php endif; ?>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            <?php endif; ?>
        </div>
    </main>

    <!-- Modales específicos para cada libro -->
    <?php if (!empty($data['libros'])): ?>
        <?php foreach ($data['libros'] as $libro): ?>
            <div class="modal fade" id="detalleModal<?php echo $libro['id']; ?>" tabindex="-1" aria-labelledby="detalleModalLabel<?php echo $libro['id']; ?>" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="detalleModalLabel<?php echo $libro['id']; ?>">Detalle del Libro</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-4">
                                    <img src="<?php echo $data['base_url']; ?>Assets/img/libros/<?php echo !empty($libro['imagen']) ? $libro['imagen'] : 'logo.png'; ?>" 
                                         class="img-fluid rounded" 
                                         alt="<?php echo htmlspecialchars($libro['titulo']); ?>"
                                         style="max-height: 300px; object-fit: cover;">
                                </div>
                                <div class="col-md-8">
                                    <h4 class="mb-3"><?php echo htmlspecialchars($libro['titulo']); ?></h4>
                                    <div class="mb-2">
                                        <strong>Autor:</strong> <?php echo htmlspecialchars($libro['autor_personal'] ?? 'No especificado'); ?>
                                    </div>
                                    <div class="mb-2">
                                        <strong>Editorial:</strong> <?php echo htmlspecialchars($libro['editorial'] ?? 'No especificada'); ?>
                                    </div>
                                    <div class="mb-2">
                                        <strong>Año de edición:</strong> <?php echo !empty($libro['anio_edicion']) ? date('Y', strtotime($libro['anio_edicion'])) : 'No especificado'; ?>
                                    </div>
                                    <div class="mb-2">
                                        <strong>Clasificación Dewey:</strong> <?php echo htmlspecialchars($libro['codigo_dewey'] ?? 'No especificada'); ?>
                                    </div>
                                    <div class="mb-2">
                                        <strong>Ubicación:</strong> <?php echo htmlspecialchars($libro['ubicacion'] ?? 'No especificada'); ?>
                                    </div>
                                    <div class="mb-2">
                                        <strong>Lugar de publicación:</strong> <?php echo htmlspecialchars($libro['lugar'] ?? 'No especificado'); ?>
                                    </div>
                                    <?php if (!empty($libro['descripcion'])): ?>
                                    <div class="mb-2">
                                        <strong>Descripción:</strong>
                                        <p class="mt-2"><?php echo htmlspecialchars($libro['descripcion']); ?></p>
                                    </div>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    <?php endif; ?>

    <!-- Chatbot -->
    <div class="chatbot-container">
        <div class="chatbot-icon" id="chatbotIcon">
            <i class="fa fa-comments"></i>
        </div>
        <div class="chatbot-window" id="chatbotWindow">
            <div class="chatbot-header">
                <h5>Asistente Virtual</h5>
                <button class="btn btn-link p-0 text-white" id="closeChatbot">
                    <i class="fa fa-times"></i>
                </button>
            </div>
            <div class="chatbot-body">
                <div class="chat-messages" id="chatMessages">
                    <div class="message bot-message">
                        <div class="message-content">
                            ¡Hola! Soy el asistente virtual de la biblioteca del CMFB. Puedo ayudarte a:
                            <br>📚 Buscar libros por título, autor o tema
                            <br>📍 Encontrar la ubicación de los libros
                            <br>ℹ️ Informarte sobre préstamos y devoluciones
                            <br>❓ Responder tus dudas sobre la biblioteca
                            <br><br>¿En qué puedo ayudarte hoy?
                        </div>
                    </div>
                    <button class="scroll-down-btn" id="scrollDownBtn" title="Bajar al final">&#8595;</button>
                </div>
                <div id="chatbotLoader" style="display:none; text-align:center; margin:10px 0;">
                    <span class="loader"></span>
                    <span style="font-size:13px; color:#888;">Pensando...</span>
                </div>
                <div class="chat-input">
                    <form id="chatForm" class="d-flex">
                        <input type="text" id="userInput" class="form-control" placeholder="Escribe tu pregunta aquí...">
                        <button type="submit" class="btn btn-primary" id="chatbot-send">
                            <i class="fa fa-paper-plane"></i>
                        </button>
                    </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Scripts -->
    <!-- jQuery primero -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <!-- Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <!-- Bootstrap 4.5.3 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js"></script>
    <!-- Custom JS -->
    <script src="<?php echo $data['base_url']; ?>Assets/js/main.js"></script>

    <script>
        var base_url = "<?php echo $data['base_url']; ?>";

        // Chatbot functionality
        document.addEventListener('DOMContentLoaded', function() {
            const chatbotIcon = document.getElementById('chatbotIcon');
            const chatbotWindow = document.getElementById('chatbotWindow');
            const closeChatbot = document.getElementById('closeChatbot');
            const chatForm = document.getElementById('chatForm');
            const userInput = document.getElementById('userInput');
            const chatMessages = document.getElementById('chatMessages');
            const chatbotLoader = document.getElementById('chatbotLoader');
            const scrollDownBtn = document.getElementById('scrollDownBtn');

            // Toggle chatbot window
            chatbotIcon.addEventListener('click', function() {
                chatbotWindow.classList.toggle('active');
                if (chatbotWindow.classList.contains('active')) {
                    scrollToBottom();
                }
            });

            // Close chatbot
            closeChatbot.addEventListener('click', function() {
                chatbotWindow.classList.remove('active');
            });

            function checkChatOverflow() {
                setTimeout(() => {
                    if (chatMessages.scrollHeight > chatMessages.clientHeight + 5) {
                        chatMessages.classList.add('has-overflow');
                        scrollDownBtn.style.display = 'flex';
                    } else {
                        chatMessages.classList.remove('has-overflow');
                        scrollDownBtn.style.display = 'none';
                    }
                }, 50);
            }

            scrollDownBtn.addEventListener('click', function() {
                chatMessages.scrollTop = chatMessages.scrollHeight;
            });

            function addMessage(content, isUser = false) {
                const messageDiv = document.createElement('div');
                messageDiv.className = `message ${isUser ? 'user-message' : 'bot-message'}`;
                const messageContent = document.createElement('div');
                messageContent.className = 'message-content';
                messageContent.textContent = content;
                messageDiv.appendChild(messageContent);
                chatMessages.appendChild(messageDiv);
                chatMessages.scrollTop = chatMessages.scrollHeight;
                checkChatOverflow();
            }

            function addBookSuggestions(books) {
                if (!books || books.length === 0) return;
                const suggestionsDiv = document.createElement('div');
                suggestionsDiv.className = 'message bot-message';
                const contentDiv = document.createElement('div');
                contentDiv.className = 'message-content';
                
                // Mostrar todos los libros devueltos por el backend
                books.forEach(book => {
                    const bookDiv = document.createElement('div');
                    bookDiv.className = 'book-suggestion';
                    bookDiv.innerHTML = `
                        <h6>${book.titulo}</h6>
                        <p><strong>Autor:</strong> ${book.autor_personal || book.autor || 'No especificado'}</p>
                        <p><strong>Editorial:</strong> ${book.editorial || 'No especificada'}</p>
                        <p><strong>Materia:</strong> ${book.materia || 'No especificada'}</p>
                        <p><strong>Código:</strong> ${book.codigo_libro || 'No especificado'}</p>
                        <p><strong>Ubicación:</strong> ${book.ubicacion || 'No especificada'}</p>
                        <p><strong>Estado:</strong> <span style="color:${book.estado === 'Disponible' ? 'green' : 'red'}">${book.estado || 'No especificado'}</span></p>
                    `;
                    contentDiv.appendChild(bookDiv);
                });
                suggestionsDiv.appendChild(contentDiv);
                chatMessages.appendChild(suggestionsDiv);
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }

            // Lista de saludos y presentaciones comunes
            const saludos = [
                'hola', 'buenos días', 'buenas tardes', 'buenas noches', 'saludos',
                'mucho gusto', 'encantado', 'encantada', 'un placer', 'gusto en conocerte',
                'como estas', 'cómo estás', 'que tal', 'qué tal', 'bienvenido', 'bienvenida'
            ];

            chatForm.addEventListener('submit', async function (e) {
                e.preventDefault();
                const consulta = userInput.value.trim();
                if (!consulta) return;

                // Agregar mensaje del usuario
                addMessage(consulta, true);
                userInput.value = '';
                chatbotLoader.style.display = 'block';

                // Verificar si es un saludo
                const esSaludo = saludos.some(saludo => 
                    consulta.toLowerCase().includes(saludo.toLowerCase())
                );

                if (esSaludo) {
                    addMessage("¡Hola! Soy Mister Biblio, ¿en qué puedo ayudarte hoy? Puedo ayudarte a buscar libros, informarte sobre nuestros servicios o responder tus preguntas sobre la biblioteca.");
                    chatbotLoader.style.display = 'none';
                    return;
                }

                try {
                    const respuesta = await fetch(base_url + 'Chatbot/obtenerRespuesta', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'query=' + encodeURIComponent(consulta)
                    });
                    const output = await respuesta.text();
                    let datos;
                    try {
                        datos = JSON.parse(output);
                    } catch (e) {
                        console.error("Respuesta no es JSON válido:", output);
                        addMessage("Lo siento, ha ocurrido un error al procesar la respuesta del servidor.");
                        chatbotLoader.style.display = 'none';
                        return;
                    }
                    addMessage(datos.respuesta);
                    if (datos.libros && datos.libros.length > 0) {
                        addBookSuggestions(datos.libros);
                    }
                } catch (error) {
                    console.error("Error al procesar la respuesta del script Python:", error);
                    addMessage("Lo siento, ha ocurrido un error al procesar tu consulta.");
                } finally {
                    chatbotLoader.style.display = 'none';
                }
            });

            // Llama a checkChatOverflow al cargar la página
            checkChatOverflow();
        });

        // --- BÚSQUEDA EN TIEMPO REAL ---
        document.getElementById('searchTitle').addEventListener('input', realizarBusqueda);
        document.getElementById('searchAuthor').addEventListener('input', realizarBusqueda);

        function realizarBusqueda() {
            const title = document.getElementById('searchTitle').value.trim();
            const author = document.getElementById('searchAuthor').value.trim();
            const dewey = document.getElementById('searchDewey').value;

            let url = window.location.pathname + '?ajax=1';
            const params = new URLSearchParams();
            if (title) params.append('title', title);
            if (author) params.append('author', author);
            if (dewey) params.append('dewey', dewey);
            if (params.toString()) {
                url += '&' + params.toString();
            }

            fetch(url)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('libros-container').innerHTML = html;
                });
        }

        // Actualizar el valor del campo dewey cuando se hace clic en los botones de categoría
        document.querySelectorAll('.btn-outline-primary, .btn-primary').forEach(button => {
            button.addEventListener('click', function(e) {
                const dewey = this.getAttribute('href').match(/dewey=(\d+)/)?.[1] || '';
                document.getElementById('searchDewey').value = dewey;
            });
        });

        // ========== CARRUSEL ========== //
        function loadCarouselItems() {
            fetch(base_url + 'Carousel/getCarouselItems')
            .then(response => response.json())
            .then(data => {
                const carouselItems = document.getElementById('carouselItems');
                const carouselIndicators = document.getElementById('carouselIndicators');
                    if (!carouselItems || !carouselIndicators) return;

                carouselItems.innerHTML = '';
                carouselIndicators.innerHTML = '';

                data.forEach((item, index) => {
                        const imageUrl = base_url + item.image_path;
                        
                    carouselIndicators.innerHTML += `
                            <li data-target="#mainCarousel" data-slide-to="${index}" ${index === 0 ? 'class="active"' : ''}></li>
                    `;
                        
                    carouselItems.innerHTML += `
                        <div class="carousel-item ${index === 0 ? 'active' : ''}">
                            <div class="carousel-content" style="background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('${imageUrl}'); cursor: pointer;" onclick="expandCarouselImage('${imageUrl}')">
                                    <div class="carousel-caption">
                                        <h2>${item.title}</h2>
                                        <p>${item.description}</p>
                                        ${item.button_text ? `<a href="${item.button_link}" class="btn btn-primary">${item.button_text}</a>` : ''}
                                </div>
                            </div>
                        </div>
                    `;
                });

                    // Inicializar el carousel
                    $('#mainCarousel').carousel({
                        interval: 5000
                    });
                })
                .catch(error => console.error('Error:', error));
        }

        function expandCarouselImage(imageUrl) {
            const expandedImage = document.getElementById('expandedCarouselImage');
            if (expandedImage) {
                expandedImage.src = imageUrl;
                $('#carouselImageModal').modal('show');
            }
        }

        // ========== INICIALIZACIÓN ========== //
        $(document).ready(function() {
            // Cargar carousel
            loadCarouselItems();
        });
    </script>
</body>
</html>