<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Chatbot Biblioteca Pública</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="<?php echo base_url; ?>Assets/css/custom.css">
    <style>
        html, body {
            width: 100vw;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            background: #f8f9fa;
            overflow-x: hidden;
        }
        .chatbot-page-center {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            width: 100vw;
            padding-top: 40px;
        }
    </style>
</head>
<body>
    <?php require_once __DIR__ . '/partials/public_header.php'; ?>
    <div class="chatbot-page-center">
        <?php require_once __DIR__ . '/partials/chatbot.php'; ?>
    </div>
</body>
</html> 