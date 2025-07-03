<?php
// Detecta automáticamente el dominio y protocolo
$protocolo = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https://' : 'http://';
$host = $_SERVER['HTTP_HOST'];
$path = '/biblio/'; // Cambia esto si tu proyecto está en otra carpeta

define('base_url', $protocolo . $host . $path);
const host = "localhost";
const user = "root";
const pass = "";
const db = "biblioteca";
const charset = "charset=utf8";
?>