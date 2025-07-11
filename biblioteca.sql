-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-07-2025 a las 19:53:33
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `biblioteca`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor`
--

CREATE TABLE `autor` (
  `id` int(11) NOT NULL,
  `autor` varchar(150) NOT NULL,
  `imagen` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor_libro`
--

CREATE TABLE `autor_libro` (
  `id` int(11) NOT NULL,
  `id_autor` int(11) NOT NULL,
  `id_libro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carousel_items`
--

CREATE TABLE `carousel_items` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `button_text` varchar(100) DEFAULT NULL,
  `button_link` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) NOT NULL,
  `order_number` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `carousel_items`
--

INSERT INTO `carousel_items` (`id`, `title`, `description`, `button_text`, `button_link`, `image_path`, `order_number`, `is_active`, `created_at`, `updated_at`) VALUES
(2, 'Colegio Militar Francisco Bolognesi', 'Bienvenidos', '', '', 'Assets/img/carousel/1750105895_B554A513-1536x1024.jpg', 0, 1, '2025-06-10 00:11:02', '2025-06-16 20:31:35'),
(3, 'Bienvenidos a la biblioteca virtual', 'Se puede usar el chatbot para las consultas', '', '', 'Assets/img/carousel/1750105938_IMG_2980.JPEG', 0, 1, '2025-06-10 00:13:02', '2025-06-16 20:32:18'),
(4, 'hola', 'kgjhg', '', '', 'Assets/img/carousel/1749577317_Pruebas02.png', 0, 0, '2025-06-10 14:57:56', '2025-06-16 20:32:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `chatbot_logs`
--

CREATE TABLE `chatbot_logs` (
  `id` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `respuesta` text NOT NULL,
  `tiempo_respuesta` decimal(10,3) NOT NULL DEFAULT 0.000,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `chatbot_logs`
--

INSERT INTO `chatbot_logs` (`id`, `mensaje`, `respuesta`, `tiempo_respuesta`, `fecha_hora`) VALUES
(430, 'quiero un libro sobre cartas', '¡Encontramos \"Las cartas de San Francisco Javier\"! Esta obra escrita por Francisco Javier y José Sola es relevante en ese tema. También te recomendamos \"Cartas Griegas\". Ambos libros están disponibles en la ubicación mencionada.', 0.000, '2025-06-15 08:04:09'),
(431, 'quiero un libro sobre cartas', '¡Encontramos \"Las cartas de San Francisco Javier\"! Este libro contiene las cartas escritas por el santo español durante su misiones en América. También recomendamos \"Cartas de amor entre las cartas\" de Jorge Luis Borges y Adolfo Bioy Casares, que explora la temática de las correspondencias a través de una fábula.', 0.000, '2025-06-15 08:04:23'),
(432, 'quiero un libro sobre cartas', 'Encontramos \"Las cartas de San Francisco Javier\" por autores Francisco Javier y José Sola. Está disponible en la ubicación E1, B - ESTE, FILA 3, DERECHA.', 0.000, '2025-06-15 08:35:41'),
(433, 'Dónde está Certeza de un futuro Mejor', 'El libro \"Certeza de un futuro Mejor\" se encuentra en E1, B - ESTE, FILA 3, DERECHA. Está disponible.', 0.000, '2025-06-15 08:53:39'),
(434, 'Tienes libros de Gabriel García Márquez', 'No he encontrado libros de Gabriel García Márquez en este momento.', 0.000, '2025-06-15 09:02:53'),
(435, 'Qué libros tienes de matemáticas', 'Encuentro dos libros relacionados con Matemáticas: \"Matemática, colección de enciclopedias monográficas Tomo 3 - Cálculo y Análisis\" y \"Matemática, colección de enciclopedias monográficas Tomo 4 - Geometría y Trigonometría\". Ambos libros están disponibles en la ubicación E1, A - OESTE, FILA 4, DERECHA.', 0.000, '2025-06-15 09:03:53'),
(436, 'Busco libros de historia', 'Encontramos el libro \"Introduccion a la filosofia de la historia\" de Raymond Aron. También recomendamos \"La Edad Moderna: una historia intelectual\" de Peter Burke. Ambos libros están disponibles en nuestra biblioteca.', 0.000, '2025-06-15 09:05:12'),
(437, 'Qué libros similares a el colonialismo tienes', '1. \"Imperialism: A Study\" por Vladimir Lenin, ubicación: D5, A - Oeste, Fila 4, Derecha, Estado: Disponible.\n2. \"The Wretched of the Earth\" por Frantz Fanon, ubicación: B6, C - Este, Fila 2, Izquierda, Estado: Disponible.', 0.000, '2025-06-15 09:06:23'),
(438, 'tienes libros de carl marx', '¡Sí, encontramos el libro \"El capital visto por su autor\" de Karl Marx y Friedrich Engels en la estantería E1, B - ESTE. Este libro está disponible para tomar prestado.', 0.000, '2025-06-15 09:07:51'),
(439, 'De qué trata el libro certeza de un mundo mejor', 'Lo siento, no tengo información detallada sobre el contenido de \'Certeza de un futuro Mejor\'. Es un libro de Religión escrito por Víctor E. Ampuero Matta.', 0.000, '2025-06-15 09:13:05'),
(440, 'De qué trata las cartas de san francisco', 'Lo siento, no tengo información detallada sobre el contenido de \'Las cartas de San Francisco Javier\'. Es un libro de Religión escrito por Francisco Javier, José Sola.', 0.000, '2025-06-15 09:13:26'),
(441, 'de que trata las cartas de san francisco', 'Lo siento, no tengo información detallada sobre el contenido de \'Las cartas de San Francisco Javier\'. Es un libro de Religión escrito por Francisco Javier, José Sola.', 0.000, '2025-06-15 09:13:46'),
(442, 'de que trata el colonialismo', 'Lo siento, no puedo generar un resumen detallado para \'El Colonialismo\'. Sin embargo, puedo decirte que es un libro de Ciencias Sociales escrito por Carlos Marx.', 0.000, '2025-06-15 10:26:12'),
(443, 'de q trata cartas de san francisco', 'Los \"Las cartas de San Francisco Javier\" son una colección de correspondencias escritas por San Francisco Javier. Estas cartas presentan su experiencia en Asia y América del Sur durante el siglo XVI.', 0.000, '2025-06-15 10:27:24'),
(444, 'cuantas enciclopedias tienen', 'Encuentro una enciclopedia disponible en la biblioteca: Enciclopedia Universal Ilustrada Tomo XV. No encuentro más enciclopedias actualmente.', 0.000, '2025-06-15 10:31:42'),
(445, 'otra enciclopedia', '¡Sí! Encontramos otra enciclopedia interesante llamada \"Enciclopedia Británica\" (Tomos 1-32). También tenemos la \"Gran Enciclopedia Popular Viking\" (Tomo 21). Ambas están ubicadas en la fila 1, derecha.', 0.000, '2025-06-15 13:42:56'),
(446, 'de que autor es ciencia y salud con clave de las escrituras', 'El libro \"Ciencia y Salud con clave de las Escrituras\" no fue encontrado en nuestra base de datos. El libro más cercano que podrías encontrar sobre este tema puede ser \"La medicina bíblica\", del autor Moisés de Mora, ubicado en la sección F1, Fila 4, Izquierda. También puedes revisar el libro \"Salud y Sanidad en la Biblia\" de José María Zornoza, ubicado en la sección B-ESTE, Fila 2, Derecha.', 0.000, '2025-06-15 14:51:33'),
(447, 'un libros sobre salud', 'Sí, encontramos algunos libros sobre salud. Recomendamos \"El libro de la salud: La guía para vivir mejor\" por Deepak Chopra y \"Cómo cambiar el mundo con la comida\" por John Robbins. Ambos se encuentran en la biblioteca, estado: disponible.', 0.000, '2025-06-15 14:52:55'),
(449, 'tienes algun documento del vaticano', '¡Sí! Tiene disponible el \"Documentos Completos del Vaticano II\" en la ubicación E1, B - ESTE, FILA 3, DERECHA.', 0.000, '2025-06-15 15:48:48'),
(450, 'tienen libros de carl marx', '¡Sí! Encontramos el libro \"El capital visto por su autor\" de Karl Marx y Friedrich Engels. Esta obra está disponible en la estantería E1, fila 1, izquierda.', 0.000, '2025-06-15 15:50:05'),
(451, 'tienen libros sobre el colonialismo', 'Sí, encontramos libros sobre colonialismo. El más relevante es \"El Colonialismo\" de Carlos Marx, que se encuentra en E1, B - ESTE, FILA 1, IZQUIERDA y está disponible. Otra recomendación es el libro \"Colonialismo y Anticolonialismo\" de Aimé Césaire.', 0.000, '2025-06-15 15:51:40'),
(452, 'dame libros sobre arte', 'Aquí están dos libros sobre arte que encontramos: \"La libertad en el arte\" de Honor Arundel (Disponible en E1, B - ESTE, FILA 1, IZQUIERDA). También recomendamos \"El arte del siglo XX\" de Alfred Barr (Disponible en E2, B - SUR, FILA 2, DERECHA).', 0.000, '2025-06-15 15:52:27'),
(453, 'de que trata la libertad en el arte', 'Lo siento, no puedo generar un resumen detallado para \'La libertad en el arte\'. Sin embargo, puedo decirte que es un libro de Ciencias Sociales escrito por Honor Arundel.', 0.000, '2025-06-15 15:53:08'),
(454, 'de que trata cartas de san francisco', 'Lo siento, no puedo generar un resumen detallado para \'Las cartas de San Francisco Javier\'. Sin embargo, puedo decirte que es un libro de Religión escrito por Francisco Javier, José Sola.', 0.000, '2025-06-15 15:53:26'),
(455, 'de que trata las cartas de san francisco', 'Lo siento, no puedo generar un resumen detallado para \'Las cartas de San Francisco Javier\'. Sin embargo, puedo decirte que es un libro de Religión escrito por Francisco Javier, José Sola.', 0.000, '2025-06-15 15:53:41'),
(456, 'de que trata las cartas de saan francsico', ' El libro \"Las cartas de San Francisco Javier\" ofrece una perspectiva simbólica y eficaz de la actividad misionera de San Francisco Javier, a pesar de que nunca llegó a América. La obra se refiere al emblema Somnium Xaverii de subsidio Indis ferendo publicado en 1640, que metafóricamente muestra la llegada de San Francisco a América a través de un sueño. El libro destacan los pasos y gestos de San Francisco como marcas para una ruta de conversión religiosa y transmite un mensaje heroico para el futuro. Además, comparte con el relato clásico de Eneas que llevaba entre sus brazos a su padre Anquises, donde se describe al joven como el fundador de un nuevo linaje.', 71.836, '2025-06-15 16:04:57'),
(457, 'de que trata las cartas de saan francsico', ' El libro \"Las cartas de San Francisco Javier\" ofrece una perspectiva simbólica y eficaz de la actividad misionera de San Francisco Javier, a pesar de que nunca llegó a América. La obra se refiere al emblema Somnium Xaverii de subsidio Indis ferendo publicado en 1640, que metafóricamente muestra la llegada de San Francisco a América a través de un sueño. El libro destacan los pasos y gestos de San Francisco como marcas para una ruta de conversión religiosa y transmite un mensaje heroico para el futuro. Además, comparte con el relato clásico de Eneas que llevaba entre sus brazos a su padre Anquises, donde se describe al joven como el fundador de un nuevo linaje.', 0.000, '2025-06-15 16:04:57'),
(458, 'hola', 'No encontré libros que coincidan con tu búsqueda. ¿Podrías ser más específico?', 0.000, '2025-06-15 20:46:59'),
(459, 'hola', 'No encontré libros que coincidan con tu búsqueda. ¿Podrías ser más específico?', 0.000, '2025-06-15 20:47:03'),
(460, 'dame un libro sobre cartas', 'Aquí tienes \"Las cartas de San Francisco Javier\" por Francisco Javier y José Sola. Este libro está disponible en la ubicación E1, B - ESTE, FILA 3, DERECHA.', 0.000, '2025-06-15 20:48:51'),
(461, 'de que trata', 'Este libro se refiere a la obra filosófica de María Zambrano. Trata sobre la naturaleza del alma y sus características metafísicas. (Título: Hacia un saber sobre el alma / Autor: María Zambrano)', 0.000, '2025-06-15 20:49:21'),
(462, 'de que trata las cartas de javier', ' El libro \"Las cartas de San Francisco Javier\" escrita por Francisco Javier y José Sola, explora la perspectiva de actividad misionera a través de una interpretación simbólica del emblema Somnium Xaverii de subsidio Indis ferendo. Este libro metafóricamente representa la llegada de San Francisco Javier a América a pesar de que nunca pudo llegar allí en vida, y lo presenta como un misionero heroico que carga a los indígenas en sus espaldas. El libro ofrece una visión anacrónica del papel de San Francisco Javier en la conversión religiosa y se relaciona con el clásico mito griego de Eneas llevando a su padre Anquises, destacándose su relevancia histórica y social.', 68.819, '2025-06-15 20:50:47'),
(463, 'de que trata las cartas de javier', ' El libro \"Las cartas de San Francisco Javier\" escrita por Francisco Javier y José Sola, explora la perspectiva de actividad misionera a través de una interpretación simbólica del emblema Somnium Xaverii de subsidio Indis ferendo. Este libro metafóricamente representa la llegada de San Francisco Javier a América a pesar de que nunca pudo llegar allí en vida, y lo presenta como un misionero heroico que carga a los indígenas en sus espaldas. El libro ofrece una visión anacrónica del papel de San Francisco Javier en la conversión religiosa y se relaciona con el clásico mito griego de Eneas llevando a su padre Anquises, destacándose su relevancia histórica y social.', 0.000, '2025-06-15 20:50:47'),
(464, 'donde estan los libros nuevos?', 'Los libros nuevos se encuentran en la Sección A.', 0.000, '2025-06-15 20:52:27'),
(465, 'donde estan los libros nuevos?', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', 0.000, '2025-06-15 21:00:06'),
(466, 'donde estan los libros nuevos?', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', 0.000, '2025-06-15 21:02:13'),
(467, 'donde estan los libros nuevos?', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', 0.000, '2025-06-15 21:03:33'),
(468, 'tienes libros de arte', 'Lo siento, no encontré libros sobre ese tema. ¿Podrías ser más específico?', 0.000, '2025-06-15 21:03:37'),
(469, 'tienes libros de cartas', 'Lo siento, no encontré libros sobre ese tema. ¿Podrías ser más específico?', 0.000, '2025-06-15 21:03:46'),
(470, 'tienes libros sobre amor', 'Sí, tenemos el libro \"Historias del Amor\" de M. Grepon disponible para ti.', 0.000, '2025-06-15 21:04:58'),
(471, 'tienes libros sobre arte', 'Sí, tengo un libro sobre arte llamado \"La libertad en el arte\" escrito por Honor Arundel. Está disponible en E1, B - ESTE, FILA 1, IZQUIERDA.', 0.000, '2025-06-15 21:05:26'),
(472, 'donde estan los libros nuevos?', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', 0.000, '2025-06-15 21:06:09'),
(473, 'tienes libros sobre cartas o enciclicas', '¡Sí, encontramos un libro relevante sobre libros y su historia! Aquí está \"Panorama, colección de enciclopedias monográficas Tomo 1 - Libros en el Tiempo\". También recomendamos \"Cartas: La Historia de su Papel y Importancia\" que también puede ser útil. Ambos libros están disponibles en la biblioteca.', 0.000, '2025-06-15 21:06:44'),
(474, 'donde esta cartas la historia de su papel', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', 0.000, '2025-06-15 21:07:43'),
(475, 'Cartas: La Historia de su Papel y Importancia\"', 'El libro \"Cartas: La Historia de su Papel y Importancia\" no fue encontrado. Sin embargo, te recomiendo los siguientes libros:\n1. \"Introducción a la Filosofía de la Historia\" por Raymond Aron\n2. \"La Filosofía de la Historia\" por Karl Popper. Ambos libros están disponibles y ubicados en E1, B - ESTE, FILA 2, DERECHA.', 0.000, '2025-06-15 21:08:26'),
(476, 'tienes libros sobre cartas', '¡Sí! Encontramos el libro \"Las cartas de San Francisco Javier\" escrito por Francisco Javier y José Sola. Está disponible en la ubicación E1, B - ESTE, FILA 3, DERECHA.', 0.000, '2025-06-15 21:09:02'),
(477, 'de que trata las cartas de san francisco', ' El libro \"Las cartas de San Francisco Javier\" de Francisco Javier y José Sola presenta una perspectiva metafórica sobre la misionera actividad de San Francisco Javier, quien en realidad nunca llegó a América. La obra se basa en el emblema \"Somnium Xaverii de subsidio Indis ferendo\" del libro Imago Primi Saeculi publicado en Amberes en 1640. El libro presenta la imagen de Javier como un misionero que carga a un indígena en su espalda, representando la difusión de la fe y la conversión religiosa. La obra combina símbolos e iconografía para transmitir un mensaje heroico y efectivo sobre la misionería.', 0.000, '2025-06-15 21:12:14'),
(478, 'mme puedes recomendar un libro similar al colonialismo', '¡Sugiero el libro \"Imperialismo, de Filippo Tommaso Marinetti o \"La teoría general del déficit, de Rudyard Kipling!\" Ambos están ubicados en la biblioteca y abordan temas similares al colonialismo.', 0.000, '2025-06-16 07:30:00'),
(479, 'mme puedes recomendar un libro similar al colonialismo', '¡Claro! Aquí tienes algunos libros similares a \"El Colonialismo\" de Karl Marx:\n\n1. \"La Teoría General de la Decadencia en el Imperio Romano\" de Arnold Toynbee (Ubicación: E2, B - OESTE, FILA 3, CENTRO)\n2. \"Imperialismo, Ejercito y Estado Moderno\" de J.A. Hobson (Ubicación: E4, B - ESTE, FILA 2, IZQUIERDA)', 0.000, '2025-06-16 07:34:08'),
(480, 'mme puedes recomendar un libro similar al colonialismo', '¡Claro! Sugiero un libro llamado \"Imperialismo, una obra de teoría económica\" también escrito por Karl Marx y Friedrich Engels. Este trabajo explica cómo el imperialismo es el último estudio de la historia del capitalismo. Aunque no es exactamente el mismo tema que El Colonialismo, ambos trabajos tienen un enfoque similar al análisis de la interacción entre los países desarrollados y los países subdesarrollados, lo que puede ser útil para ti. El libro se encuentra en la misma estantería (E1, B - ESTE, FILA 1, IZQUIERDA) y también está disponible.', 0.000, '2025-06-16 07:41:00'),
(481, 'tienen acerca del estado de lenin', '¡Bienvenido! El libro \"Acerca del estado de Vladimir Il\'ich Lenin\" está disponible en la ubicación E1, B - Este, Fila 1, Izquierda. Espero que encuentres la información que necesitas en él. No dudes en preguntar si tienes alguna pregunta más sobre el libro o cualquier otro tema relacionado con Lenin u otras figuras históricas.', 0.000, '2025-06-16 17:02:59'),
(482, 'tienes libros sobre historia dame uno', '¡Sigo buscando el libro \"Problemas de filosofía de la historia\" del autor Georg Simmel! Esto es un libro clásico en la disciplina de Historia y Filosofía. Es un excelente recurso para aquellos que deseen entender cómo se relaciona la teoría con la práctica histórica, y cómo los conceptos filosóficos pueden aplicarse al estudio del pasado.\n\nEl libro \"Problemas de filosofía de la historia\" fue publicado por primera vez en 1905, y sigue siendo un texto muy relevante para estudiosos de Historia y Filosofía. El autor Georg Simmel era un sociólogo alemán que exploraba una variedad de temas filosóficos y sociales, y este libro es uno de sus trabajos más famosos en la disciplina de la Historia y la Filosofía.\n\nA continuación, te comparto un resumen del libro:\n\n- Título: Problemas de filosofía de la historia\n- Autor: Georg Simmel\n- Editorial: Sucesora de Routledge & Kegan Paul Ltd\n- Idioma: Inglés\n- ISBN: 9780415239206\n- Número de páginas: 219\n\nEspero que este libro te sea útil en tu investigación sobre Historia y Filosofía.', 0.000, '2025-06-16 17:08:44'),
(483, 'que alumno tiene prestamos', 'Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?', 0.000, '2025-06-17 00:07:04'),
(484, 'que alumno tiene prestamos', 'Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?', 0.000, '2025-06-17 00:07:17'),
(485, 'libro sobre el alma', 'He encontrado 1 libros sobre el alma. Aquí están los resultados:', 0.000, '2025-06-17 00:07:28'),
(486, 'donde estan los libros neuvos', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', 0.000, '2025-06-17 00:38:57'),
(487, 'tienes libros de carl marx', '¡Tengo el libro \"El Capital\" escrito por Karl Marx y Friedrich Engels! La ubicación del libro es E1, B - ESTE, FILA 1, IZQUIERDA y se encuentra disponible para su uso.', 0.000, '2025-06-17 00:39:37'),
(488, 'de que trata el capital visto por su autor', ' Este resumen proporciona una precisa síntesis del contenido de los tres volúmenes completos de \"El Capital\" de Karl Marx y Friedrich Engels. Ofrece un compendio detallado, capítulo a capítulo, de la teoría económica marxista sobre el origen, la naturaleza y las consecuencias del capitalismo. La utilidad principal del libro es facilitar la lectura completa y paralela de la obra original de Marx.', 0.000, '2025-06-17 00:40:54'),
(489, 'tienes algun libro de carl marx', '¡Claro que sí! Aquí tienes información sobre el libro \"El capital\", escrito por Karl Marx y Friedrich Engels. La ubicación del libro es la sección E1, B - ESTE, en la fila 1 y columna de la izquierda. Su estado es disponible para ser prestado. Recuerda que debes tener una tarjeta de la biblioteca para poder solicitar el préstamo del libro.', 0.000, '2025-06-17 10:10:27'),
(490, 'me oeudes recomendar un libro similar al colonialismo', '¡Por supuesto! A continuación te recomiendo algunos libros que tratan sobre temas relacionados con el colonialismo y son similares al \"El Colonialismo de Carlos Marx\".\n\n* Imperio (Edward Said, 1978)\n* El imperialismo como factor en la acumulación del capital (Vladimir Lenin, 1916)\n* Imperialismo y cultura: ensayos sobre el colonialismo cultural (Aimé Césaire, 1955)\n* Orientalism (Edward Said, 1978)\n* La invención de la raza pura (Frankenberg, Ann, 1993)\n* El mito del desarrollo: Desarrollo económico, colonialismo y poscolonialismo (Samir Amin, 1974)\n* Del tercer mundo al mundo global: la evolución de la teoría de los movimientos sociales en el siglo XX (Immanuel Wallerstein, 1989)\n* La raza y la suerte del hombre blanco (Frances Cress Welsing, 1970)\n\nEspero que estos libros te ayuden a entender mejor los temas relacionados con el colonialismo y la globalización. ¡Buena lectura!', 0.000, '2025-06-18 13:35:14'),
(491, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', '¡Tienes dos opciones interesantes que te podría recomendar en español relacionadas con el psicoanálisis!\n\n1. \"Obras completas de Sigmund Freud\" por Sigmund Freud (Ubicación: F, A - SUR, COLUMNA 2, DERECHA, Estado: Disponible)\nEn esta obra encontrarás muchos de los textos fundamentales escritos por el padre del psicoanálisis, con enfoque en su teoría y práctica.\n\n2. \"El jardín de las palabras\" por Carlos Castañeda (Ubicación: G, E - SUR, COLUMNA 1, DERECHA, Estado: Disponible)\nMientras que este libro no es un texto psicoanalítico en el sentido estricto del término, sigue siendo una obra influyente en la investigación de la conciencia humana y los procesos mentales. Castañeda describe su experiencia personal con don Juan Matus, un maestro mexicano que le enseña a viajar entre los mundos del espíritu, lo que podría ser interesante para aquellos que están buscando una perspectiva diferente sobre la mente humana.', 0.000, '2025-06-18 13:39:25'),
(492, 'me ouedes recomendar un libro parecido a antropologia filosofica', '¡Por supuesto! A continuación te recomiendo algunos libros similares a \"Antropología filosófica\" de Augusto Salazar Bondy que están disponibles en tu biblioteca.\n\n1. El hombre invisible y sus instituciones por Émile Durkheim (Ubicación: E1, A - ESTE, FILA 1, IZQUIERDA, Estado: Disponible)\nEl libro de Durkheim es una clásica en la antropología social que examina las instituciones sociales y cómo influencian el comportamiento humano.\n\n2. La división del trabajo social por Max Weber (Ubicación: E1, C - ESTE, FILA 1, IZQUIERDA, Estado: Disponible)\nEn este libro, Weber examina la forma en que los grupos sociales son organizados en función de su estructura económica y políticas.\n\n3. El hombre moldeable por John B. Watson (Ubicación: E1, D - ESTE, FILA 2, IZQUIERDA, Estado: Disponible)\nWatson es uno de los padres fundadores de la psicología behaviorista y este libro es una presentación de su teoría sobre el aprendizaje humano.\n\n4. El hombre y sus instituciones sociales por Alfredo Gutiérrez Hererra (Ubicación: E1, F - ESTE, FILA 2, IZQUIERDA, Estado: Disponible)\nEste libro es una presentación de la antropología social desde una perspectiva latinoamericana y se centra en el estudio de las instituciones sociales y culturales en el continente americano.\n\n5. La muerte y la locura por Michel Foucault (Ubicación: E1, H - ESTE, FILA 3, IZQUIERDA, Estado: Disponible)\nEn este libro, Foucault examina cómo las instituciones sociales han influido en la percepción y el tratamiento de los enfermos mentales y los muertos a lo largo de la historia.', 0.000, '2025-06-18 21:40:09'),
(493, 'me oeudes recomendar un libro similar al colonialismo', 'Te recomiendo los siguientes libros:\n- El Colonialismo de Carlos Marx (No disponible en la biblioteca, pero recomendado)\n- El espíritu de la filosofía moderna de Royce Josiah, Vicente P. Quintero (Disponible en la biblioteca)\n- Breve historia del periódico norteamericano de John Tebbel, Enrique Gual (Disponible en la biblioteca)', 0.000, '2025-06-19 07:53:47'),
(494, 'me oeudes recomendar un libro similar al colonialismo', 'Te recomiendo los siguientes libros:\n- El Colonialismo de Carlos Marx (No disponible en la biblioteca, pero recomendado)\n- El espíritu de la filosofía moderna de Royce Josiah, Vicente P. Quintero (Disponible en la biblioteca)\n- Breve historia del periódico norteamericano de John Tebbel, Enrique Gual (Disponible en la biblioteca)', 0.000, '2025-06-19 07:53:53'),
(495, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', 'Te recomiendo los siguientes libros:\n- Antología del psicoanálisis de Elemire Zolla (Disponible en la biblioteca)\n- El psicoanalisis de Antonio Miotto, Baltasar, Tr Samper (Disponible en la biblioteca)\n- Introducción al psicoanálisis para educadores de Anna Freud (Disponible en la biblioteca)', 0.000, '2025-06-19 07:54:38'),
(496, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', 'Te recomiendo los siguientes libros:\n- Antología del psicoanálisis de Elemire Zolla (Disponible en la biblioteca)\n- El psicoanalisis de Antonio Miotto, Baltasar, Tr Samper (Disponible en la biblioteca)\n- Introducción al psicoanálisis para educadores de Anna Freud (Disponible en la biblioteca)', 0.000, '2025-06-19 07:58:47'),
(497, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', 'Te recomiendo los siguientes libros:\n- Antología del psicoanálisis de Elemire Zolla (Disponible en la biblioteca)\n- El psicoanalisis de Antonio Miotto, Baltasar, Tr Samper (Disponible en la biblioteca)\n- Introducción al psicoanálisis para educadores de Anna Freud (Disponible en la biblioteca)', 0.000, '2025-06-19 07:58:58'),
(498, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', 'Te recomiendo los siguientes libros:\n- Antología del psicoanálisis de Elemire Zolla (Disponible en la biblioteca)\n- El psicoanalisis de Antonio Miotto, Baltasar, Tr Samper (Disponible en la biblioteca)\n- Introducción al psicoanálisis para educadores de Anna Freud (Disponible en la biblioteca)', 0.000, '2025-06-19 08:00:01'),
(499, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', 'Te recomiendo los siguientes libros:\n- Antología del psicoanálisis de Elemire Zolla (Disponible en la biblioteca)\n- El psicoanalisis de Antonio Miotto, Baltasar, Tr Samper (Disponible en la biblioteca)\n- Introducción al psicoanálisis para educadores de Anna Freud (Disponible en la biblioteca)', 0.000, '2025-06-19 08:00:13'),
(500, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', 'Te recomiendo los siguientes libros:\n- Antología del psicoanálisis de Elemire Zolla (Disponible en la biblioteca)\n- El psicoanalisis de Antonio Miotto, Baltasar, Tr Samper (Disponible en la biblioteca)\n- Introducción al psicoanálisis para educadores de Anna Freud (Disponible en la biblioteca)', 0.000, '2025-06-19 08:13:34'),
(501, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', '¡Claro que sí! Si te gusta la obra de Elemire Zolla \"Antología del psicoanálisis\", te recomendaría el siguiente libro:\n\n* Sigmund Freud: La Introducción a las Psicología (Traducido por Enrique Lazaro y Vicente Guerrero) - Ubicación: E1, C - SUR, COLUMNA 5, DERECHA, Estado: Disponible\n\nEste libro es una recopilación de los escritos fundamentales de Sigmund Freud, considerado como el padre del psicoanálisis. Como la \"Antología del psicoanálisis\", este libro incluye conceptos claves y teorías sobre el funcionamiento humano, la mente inconsciente, los símbolos y las obsesiones. También ofrece una visión de profundidad sobre la dinámica interna y las dinámicas sociales humanas.', 0.000, '2025-06-19 08:15:50'),
(502, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', '¡Claro! Aquí te recomiendo un libro similar a la \"Antología del psicoanálisis de Elemire Zolla\":\n\n* Introducción a la Psicología de la Cultura (Vol. I y II), por Ernesto Bochner (Ubicación: HQ 10-6, B - NORTE, FILA 5, CENTRO)\n\nEstos libros son una presentación amplia e interesante de los fundamentos teóricos y prácticos de la psicología cultural, ofreciendo un enfoque multidisciplinario que combina conceptos psicoanalíticos, sociológicos, antropológicos, y filosóficos.\n\nEl autor Ernesto Bochner es un destacado psicólogo argentino, conocido por su obra pionera en la aplicación de los principios psicoanalíticos al estudio del comportamiento humano en contexto cultural. Espero que te guste y puedas encontrar este libro como una buena opción para seguir profundizando en el mundo de la psicología y su relación con la cultura.', 0.000, '2025-06-19 08:31:16'),
(503, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', '¡Para ti recomendaré un libro similar a la Antología del psicoanálisis de Elemire Zolla!\n\nPodrías considerar \"Obras maestras de la teoría psicoanalítica: Sigmund Freud, Melanie Klein, Jacques Lacan y más\" de Dario Castronovo (Ubicación: E1, B - OESTE, FILA 2, IZQUIERDA, Estado: Disponible).\n\nEste libro es una excelente selección de textos fundamentales sobre la teoría psicoanalítica que cubre importantes aportaciones de Freud, Klein, Lacan, y otros teóricos clave en el campo. También es una buena opción para estudiantes o lectores interesados en profundizar más en los conceptos y técnicas del psicoanálisis.', 0.000, '2025-06-19 10:33:12'),
(504, 'de que trata las cartas de san fracisco', ' El libro \"Las cartas de San Francisco Javier\" del autor José Sola se centra alrededor del mítico viaje del Santo Ignacio de Loyola, Francisco Javier, a América. Aunque nunca llegó a este continente, la obra ofrece una perspectiva simbólica y efectiva de su actividad misionera en Asia. El libro presenta el sueño de San Francisco como un icono para la difusión de su mensaje heroico y la conversión religiosa en el contexto de los siglos XVI y XVII, al tiempo que evoca la leyenda de Eneas llevando a su padre Anquises. El libro, publicado en 1640, es parte del centenario de la Compañía de Jesús.', 0.000, '2025-06-19 11:51:41'),
(505, 'de que trata las cartas de san fracisco', ' El libro \"Las cartas de San Francisco Javier\" de Francisco Javier y José Sola se centra en la perspectiva misionera de San Francisco Javier con un enfoque anacrónico y simbólico. A través de una imagen metafórica, el libro describe cómo Francisco Javier viaja a América por medio de un sueño, pese a que su actividad misionera se llevó a cabo en Asia hasta su fallecimiento en 1552. La obra presenta la ruta misionera de Francisco como una metáfora y transmite un mensaje heroico para el futuro, con el misionero representado cargando a un indígena sobre sus espaldas. El libro se publicó en 1640 como emblema del centenario de la Compañía de Jesús.', 0.000, '2025-06-19 14:00:40'),
(506, 'me puedes recomendar un libro sobre el capitalismo', '¡Claro! Aunque no encontré el libro específico \"El Colonialismo de Carlos Marx\" que está actualmente en préstamo, te recomiendo otros libros interesantes sobre el capitalismo basados en la ubicación dada del archivo. Aquí tienes algunos ejemplos:\n\n1. **Capital, Volumen 1** por Karl Marx - La obra más conocida de Marx, donde analiza la naturaleza y las leyes que rigen el capitalismo moderno. Ubicación: E1, B - CENTRO, FILA 2, DERECHA\n\n2. **Capital en el siglo XXI** por David Harvey - Este libro es una interpretación actualizada de la obra de Marx y analiza cómo las leyes económicas descubiertas por él siguen vigentes en el capitalismo contemporáneo. Ubicación: E1, B - CENTRO, FILA 3, DERECHA\n\n3. **La teoría general del imposible** por Slavoj Žižek - En esta obra, Žižek analiza el capitalismo desde una perspectiva marxista y postmoderna, ofreciendo una lectura provocativa de cómo funciona realmente el sistema económico actual. Ubicación: E1, B - CENTRO, FILA 4, DERECHA\n\nEspero que estas recomendaciones te sean útiles en tu búsqueda por conocer más sobre el capitalismo!', 0.000, '2025-06-19 14:09:47'),
(507, 'de que trata 7 ensayos filosoficos sobre la ciencia moderna', 'Lo siento, no puedo generar un resumen detallado para \'7 ensayos filosoficos sobre la ciencia moderna\'. Sin embargo, puedo decirte que es un libro de Filosofía y Psicología escrito por Omas R. Hofmann ; tr de Ma de Lourdes Fournier ; rev de Gerardo Quiroz Vieyra Gortari.', 0.000, '2025-06-19 17:40:55'),
(508, 'de que trata acerca del estado', 'Lo siento, no puedo generar un resumen detallado para \'Acerca del estado\'. Sin embargo, puedo decirte que es un libro de Ciencias Sociales escrito por Vladimir Il\'ich Lenin.', 0.000, '2025-06-19 17:41:09'),
(509, 'de que trata alrededor de la filosofia', ' Este libro titulado \"Alrededor de la filosofía\" escrito por Arthur Schopenhauer, recopila textos cortos que abordan la relación humana con los animales a lo largo de más de tres milenios. El trabajo ofrece una antología esencial sobre cómo nuestros pensadores y escritores han influido en nuestra comprensión actual de nuestras interacciones éticas con los animales no humanos.', 0.000, '2025-06-19 17:42:42'),
(510, 'mme puedes recomendar otro parecido a alrededor de la filosofia', '¡Claro! Si estás interesado en filosofía y quieres encontrar otro libro que te pueda fascinar de la misma manera, te recomiendo \"El arte de pensar. Filosofía práctica para todos\" de Massimo Pigliucci.\n\nEste libro es un hermoso manual de autoayuda filosófica, escrito por un filósofo científico que ha dedicado su vida a enseñar cómo la filosofía puede mejorar nuestra vida cotidiana. \"El arte de pensar\" cubre una amplia gama de temas filosóficos importantes, incluyendo ética, filosofía del lenguaje y del conocimiento, metafísica, epistemología y la filosofía de la ciencia.\n\nEste libro está disponible en el mismo estante que \"Que es la filosofia de Francisco Romero\", en la misma ubicación: E1, B - ESTE, FILA 1, IZQUIERDA. Espero que te guste!', 0.000, '2025-06-19 17:44:08'),
(511, 'de que se trata acerca del estado de lenin', 'Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?', 0.000, '2025-06-19 17:46:30'),
(512, 'de que se trata acerca del estado de lenin', 'Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?', 0.000, '2025-06-19 17:46:37'),
(513, 'de que trata acerca del estado de lenin', 'Lo siento, no puedo generar un resumen detallado para \'Acerca del estado\'. Sin embargo, puedo decirte que es un libro de Ciencias Sociales escrito por Vladimir Il\'ich Lenin.', 0.000, '2025-06-19 17:46:49'),
(514, 'puedes buscar en internet Acerca del estado Autor: Vladimir Il\'ich Lenin', 'Lo siento, no pude encontrar el libro que mencionas. ¿Podrías verificar el título?', 0.000, '2025-06-19 17:47:10'),
(515, 'que alumnos tienen prestamo', 'Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?', 0.000, '2025-06-19 17:47:43'),
(516, 'que alumnos tienen prestamo', 'Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?', 0.000, '2025-06-19 17:47:53'),
(517, 'recomiendame un libro parecido a 7 ensayos filosoficos sobre ciencia moderna', 'He encontrado 1 libros sobre ciencia moderna. Aquí están los resultados:', 0.000, '2025-06-19 18:22:02'),
(518, 'de que trata 7 ensayos filosoficos', ' \"La Religiosa, una novela publicada póstumamente por Denis Diderot en 1796, es una crítica de la vida monástica y las restricciones de la religión institucionalizada, presentando la historia real de Suzanne Simonin. La obra se estructura como una serie de cartas donde Suzanne narra su lucha por la libertad en un entorno opresivo, explorando temas como la libertad individual, la opresión y la hipocresía de las instituciones religiosas.\"', 0.000, '2025-06-19 18:24:28'),
(519, 'de que trata 7 ensayos filosoficos sobre la ciencia moderna', 'Lo siento, no puedo generar un resumen detallado para \'7 ensayos filosoficos sobre la ciencia moderna\'. Sin embargo, puedo decirte que es un libro de Filosofía y Psicología escrito por Omas R. Hofmann ; tr de Ma de Lourdes Fournier ; rev de Gerardo Quiroz Vieyra Gortari.', 0.000, '2025-06-19 18:25:32'),
(520, 'donde estan los libros nuevos', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', 0.000, '2025-06-19 18:34:34'),
(521, 'donde esstan libros neuvos', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', 0.000, '2025-06-19 18:36:42'),
(522, 'tienes libros sobre cartas o enciclicas', '¡Tienes un libro llamado \"Panorama\" que pertenece a una colección de enciclopedias monográficas! Este tomo específico es el Tomo 1 - Libros en el Tiempo. El libro se encuentra ubicado en E1, A - OESTE, FILA 4, DERECHA y está disponible para ser leído. Espero que te resulte útil para tus investigaciones!', 0.000, '2025-06-19 18:57:21'),
(523, 'no no es un libros sobre cartas', 'He encontrado 1 libros sobre cartas. Aquí están los resultados:', 0.000, '2025-06-19 18:57:39'),
(524, 'de que trata las cartas de san francisco', ' El libro \"Las cartas de San Francisco Javier\" de Francisco Javier y Jose Sola ofrece una perspectiva metafórica y simbólica del sueño de San Francisco Javier sobre su llegada a América, lugar al que nunca llegó en vida. La obra presenta una aproximación anacrónica al misionero jesuita y su actividad en Asia hasta su muerte en 1552. En el libro se destacan las metáforas del camino de San Francisco, sus gestos, y la representación del peso de la conversión religiosa que cargaba en su espalda. También incluye alusiones al relato clásico de Eneas llevando a su padre Anquises, reflejando el misionero como fundador de un nuevo linaje. El libro presenta una perspectiva eficaz y heroica sobre la labor misionera de San Francisco Javier en América.', 0.000, '2025-06-19 18:59:14'),
(525, 'me oeudes recomendar un libro similar al colonialismo', '¡Claro! Si estás buscando un libro similar a \"El Colonialismo de Karl Marx\", te recomiendo algunos libros que abordan temas similares o relacionados. Aquí te presento algunas opciones:\n\n1. \"La invención del primitivo\" de Mary Douglas - Locación: HJ12, B - OESTE, FILA 4, DERECHA, Estado: Disponible\n2. \"Imperio y subdesarrollo\" de André Gunder Frank - Locación: HD87, B - NORTE, FILA 2, IZQUIERDA, Estado: Disponible\n3. \"El impío imperio\" de Aimé Césaire - Locación: DT153, B - ESTE, FILA 1, IZQUIERDA, Estado: No disponible\n4. \"La teoría del desarraigo\" de Frantz Fanon - Locación: DT268, B - OESTE, FILA 5, DERECHA, Estado: Disponible\n5. \"El imperio en el mundo moderno\" de Michael Mann - Locación: JC417, B - SUR, FILA 1, IZQUIERDA, Estado: Disponible\n6. \"El colonialismo inglés y el origen del capitalismo\" de Eric Williams - Locación: HT901, B - ESTE, FILA 3, DERECHA, Estado: Disponible\n7. \"Imperio y globalización\" de John Agnew - Locación: JZ1285, B - SUR, FILA 2, IZQUIERDA, Estado: Disponible\n\nEspero que estas opciones te sirvan para encontrar un libro que se adapte a tus intereses.', 0.000, '2025-06-19 19:02:21'),
(526, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', '¡Claro! Te recomiendo un libro que es una colección de ensayos sobre la psicoanálisis titulado \"La Psicoanalisis en la actualidad\" (Título: La psicoanálisis en la actualidad, Ubicación: H8, A - ESTE, FILA 4, IZQUIERDA, Estado: Disponible) de Wilfred Bion. Este libro presenta una selección de sus ensayos más importantes sobre temas clave de la psicoanálisis, como el trabajo del analista y la teoría de los objetos maternales. Es un buen complemento a la \"Antología del psicoanálisis\" de Elemire Zolla y ofrece una perspectiva más profunda sobre esta disciplina.', 0.000, '2025-06-19 19:03:36'),
(527, 'dame un libro sobre cartas', 'He encontrado 1 libros sobre cartas. Aquí están los resultados:', 0.000, '2025-06-19 19:04:50'),
(528, 'de que trata las cartas de san francisco', ' El libro \"Las cartas de San Francisco Javier\" explora la leyenda del sueño de Francisco Javier que anticipa su llegada a América, un lugar donde en realidad nunca llegó en vida (muere en 1552). Este sueño se encuentra entre los emblemas del libro, publicado en Amberes en 1640 como parte del centenario de la Compañía de Jesús. El libro propone una perspectiva anacrónica y simbólica de su actividad misionera, donde Francisco Javier se presenta metafóricamente como un guía en el camino de las conversiones religiosas, llevando a un indígena sobre sus espaldas mientras dialoga con el clásico relato de Eneas que lleva entre sus brazos a su padre Anquises. El libro destaca los pasos, gestos y presencia de Francisco Javier como un mensaje heroico para el futuro.', 0.000, '2025-06-19 19:06:16'),
(529, 'de que trata el sistema de descartes', 'Lo siento, no puedo generar un resumen detallado para \'El sistema de Descartes\'. Sin embargo, puedo decirte que es un libro de Filosofía y Psicología escrito por O. Hamelin.', 0.000, '2025-06-19 19:06:38'),
(530, 'algun libro similar al sistema de descartes', '¡Hola! Si estás buscando un libro similar al \"Sistema de Descartes\" del autor O. Hamelin, te recomiendo algunos títulos que traten sobre René Descartes y su filosofía:\n\n1. \"Descartes: Filosofía y Ciencia en el Renacimiento\" (Author: John Cottingham) - Ubicación: E3, B - OESTE, COLUMNA 2, ARRIBA\n2. \"Descartes: La Meditación sobre la Método y El Principio Filosófico\" (Author: René Descartes) - Ubicación: E1, B - ESTE, FILA 3, IZQUIERDA, Estado: Disponible\n3. \"Descartes y la Tradición Metafísica\" (Authors: John Cottingham, Robert Stoothoff, Dugald Murdoch) - Ubicación: E3, B - OESTE, COLUMNA 2, ABAJO\n4. \"Descartes: La Filosofía del Tiempo\" (Author: Paul Potter) - Ubicación: E1, B - ESTE, FILA 4, DERECHA, Estado: Disponible\n5. \"Descartes: La Historia de la Mente\" (Author: William Sweetman) - Ubicación: E3, B - OESTE, COLUMNA 1, ARRIBA\n\nEstos títulos te ayudarán a profundizar en el sistema de pensamiento de René Descartes y su filosofía. Recuerda comprobar la disponibilidad física o digital del libro que más te interese para tomarlo al instante. ¡Buena lectura!', 0.000, '2025-06-19 19:08:01'),
(531, 'algun libro similar al sistema de descartes en la biblioteca', '¡Encontré un libro que podría ser interesante para ti! Su título es \"Renacimiento del Pensamiento Científico y Filosófico: Desde la Edad Media al Renacimiento\" de autores como Charles B. Schmitt, John E. Murdoch y Edward P. Mahoney.\n\nEste libro analiza los pensamientos de algunos filósofos y científicos importantes del Renacimiento europeo que influyeron en el desarrollo de la ciencia moderna y la filosofía. Incluso si no es exactamente el sistema de Descartes, se trata de un libro que explora algunas de las ideas clave que fueron desarrolladas durante el Renacimiento, por lo que podría ser interesante para ti.\n\nLa ubicación del libro en la biblioteca es: S1 - OESTE, FILA 7, CENTRO. Estado: Disponible.', 0.000, '2025-06-19 19:09:10'),
(532, 'me puedes recomendar un libro similar a antologia del psicoanalisisa de la biblioteca', '¡Por supuesto! Si estás buscando un libro que te haga pensar y te aproximes a las ideas filosóficas, puedo recomendarte uno que te podría gustar y está disponible en la biblioteca:\n\n- El misterio del ser humano : una introducción a la fenomenología de Edmund Husserl, por Ricardo Guerra (Ubicación: E1, B - OESTE, FILA 1, DERECHA, Estado: Disponible)\n\nEste libro es una introducción a las ideas de Edmund Husserl, un filósofo alemán que fundó la fenomenología. La fenomenología es una enfoque filosófico que se centra en estudiar cómo los seres humanos perciben y entienden el mundo. Esto puede ser de interés si estás buscando comprender mejores las ideas de Kant y otras corrientes filosóficas contemporáneas.\n\nEspero que esta recomendación te sea útil y que disfrutes leyendo este libro! ¡Buena suerte en tu búsqueda de conocimiento!', 0.000, '2025-06-19 19:10:44'),
(533, 'de que trata alrededor de la filosofia', ' Este libro, \"Alrededor de la filosofía\" por Arthur Schopenhauer, recopila una antología de textos breves sobre nuestra relación con los animales a lo largo de los últimos tres milenios. Ofrece testimonios esenciales para entender cómo ensayistas, filósofos y escritores han influido en la conciencia humana sobre el tratamiento de los animales no humanos, abarcando temas como instrumentalización explotadora y defensa y cuidado.', 0.000, '2025-06-19 19:13:23'),
(534, 'algun libro similar al colonialismo', '¡Claro! Si estás buscando un libro que se relaciona con el colonialismo pero no es \"El Colonialismo de Carlos Marx\", te recomiendo algunos títulos interesantes.\n\n1. \"La Cultura de la Pobreza\" por Paul Farmer: Este libro aborda cómo el colonialismo ha contribuido en la perpetuación de la pobreza y la desigualdad a nivel mundial, con un enfoque principal en Haití y en América Latina.\n\n2. \"Imperialismo, Clase Media y Literatura\" por Aimé Césaire: Este texto es una crítica de la cultura occidental desde el punto de vista de las colonias francesas del Caribe, enfatizando en la importancia de la literatura en la lucha contra el colonialismo.\n\n3. \"Negritud\" por Léopold Sédar Senghor: Escrito por el poeta y político senegalés Léopold Sédar Senghor, este libro es un testimonio de la experiencia y la conciencia colectiva de los africanos en la diáspora.\n\n4. \"El Hombre Oculto\" por Franz Fanon: Este clásico de la literatura postcolonial explora la psicología del colonizado, la violencia colonial y las tácticas de lucha para derrotar el colonialismo.\n\n5. \"El Colonialismo Tardío\" por J.M.A. Rodney: Este libro es una exploración detallada del colonialismo tardío y su impacto en América Latina, África y Asia Oriental.', 0.000, '2025-06-19 19:14:41'),
(535, 'quiero un libro sobre arte', '¡Hola! ¡Espero que estés muy bien! Sí, estoy aquí para ayudarte en lo que pueda. Según tu consulta, encontré varios libros sobre arte que podrían interesarte:\n\n1. **Enciclopedia Universal Ilustrada Tomo XVIII Parte 1 (DEM-DIR)** y **Tomó XVIII Parte 2 (DIS-ECZ)**: Estos dos tomos te proporcionan una amplia panorámica del mundo del arte. En ellos, encontrarás información sobre artistas, obras maestras, estilos artísticos y periodos históricos, entre otros temas relacionados con el arte.\n\n2. **Enciclopedia Universal Ilustrada Tomo XXVIII Parte 1 (HO-INSUS)** y **Tomó XXVIII Parte 2 (INT-KZ)**: Estos dos tomos continúan explorando el mundo del arte, especialmente te ofrecerán información acerca de las artes decorativas, arquitectura y artes aplicadas.\n\n3. **Enciclopedia Universal Ilustrada Suplemento III - 1936-39 (1ª Parte)**: Este suplemento te proporciona información sobre los avances del arte en las últimas décadas, incluyendo obras maestras de artistas contemporáneos y la evolución de diferentes estilos artísticos.\n\nRecuerda que todos estos libros se encuentran disponibles en nuestra biblioteca. Si tienes alguna pregunta adicional o necesitas más información sobre uno de estos libros, no dudes en preguntarlo. Espero que te ayude en tu consulta sobre arte! ¡Tu mejor elección es la que se sientas cómoda con!', 0.000, '2025-06-19 20:11:03'),
(536, 'me puedes recomendar un libro similar a antologia del psicoanalisis', '¡Bueno! Si estás interesado en libros sobre psicoanálisis, te recomiendo \"El Manual del Analista\" de Sigmund Freud (Ubicación: E1, A - SUR, FILA 3, IZQUIERDA, Estado: Disponible). Este libro es una colección de trabajos escritos por Freud que abarcan una amplia gama de temas relacionados con el psicoanálisis. También te puedo recomendar \"El Manual de la Terapia Psicoanalítica\" de Wilfred Bion (Ubicación: E1, A - NORTE, FILA 4, DERECHA, Estado: Disponible). Este libro ofrece una visión profunda y comprensiva de las técnicas y conceptos fundamentales de la terapia psicoanalítica. Estos libros te proporcionarán un amplio conocimiento sobre el psicoanálisis y te ayudarán a entender mejor este campo.', 0.000, '2025-06-20 19:36:02'),
(537, 'me puedes recomendar un libro similar a antologia del psicoanalisis', ' En nuestra biblioteca no tienes libros similares al Antología del psicoanálisis de Elemire Zolla. La única obra que encontramos relacionada con el tema es:\n\n- Antología del psicoanálisis de Elemire Zolla (Ubicación: E1, B - ESTE, FILA 2, IZQUIERDA, Estado: Disponible)', 0.000, '2025-06-20 19:40:44'),
(538, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', 'Basándome en \'Antología del psicoanálisis\', te recomiendo estos libros similares que están disponibles en nuestra biblioteca:\n\n1. Breve antología filosófica de Augusto Salazar Bondy\n   Ubicación: E1, B - ESTE, FILA 1, IZQUIERDA\n   Estado: Disponible\n\n2. Introducción al psicoanálisis de Sigmund Freud, Luis López Ballesteros y de Torres\n   Ubicación: E1, B - ESTE, FILA 2, IZQUIERDA\n   Estado: Disponible\n\n3. Diccionario de psicoanálisis de Jean Laplanche, Daniel Lagache, Jean-Bertrand Pontalis\n   Ubicación: E1, B - ESTE, FILA 3, IZQUIERDA\n   Estado: Disponible\n\n4. Introducción al psicoanálisis para educadores de Anna Freud\n   Ubicación: E1, B - ESTE, FILA 3, IZQUIERDA\n   Estado: Disponible\n\n5. Tomo I: De la antigüedad a comienzos del siglo XIX de \n   Ubicación: E1, B - ESTE, FILA 1, IZQUIERDA\n   Estado: Disponible\n\n', 0.000, '2025-06-20 19:43:26'),
(539, 'me oeudes recomendar un libro similar al colonialismo', 'No encontré el libro de referencia en nuestra biblioteca. ¿Podrías verificar el título o intentar con otro libro?', 0.000, '2025-06-20 19:47:51'),
(540, 'recomiendame un libro similar al colonialismo', 'No encontré el libro de referencia en nuestra biblioteca. ¿Podrías verificar el título o intentar con otro libro?', 0.000, '2025-06-20 19:48:13'),
(541, 'me puedes recomendar un libro similar a antologia del psicoanalisisa', 'Basándome en \'Antología del psicoanálisis\', te recomiendo estos libros similares que están disponibles en nuestra biblioteca:\n\n1. Breve antología filosófica de Augusto Salazar Bondy\n   Ubicación: E1, B - ESTE, FILA 1, IZQUIERDA\n   Estado: Disponible\n\n2. Introducción al psicoanálisis de Sigmund Freud, Luis López Ballesteros y de Torres\n   Ubicación: E1, B - ESTE, FILA 2, IZQUIERDA\n   Estado: Disponible\n\n3. Diccionario de psicoanálisis de Jean Laplanche, Daniel Lagache, Jean-Bertrand Pontalis\n   Ubicación: E1, B - ESTE, FILA 3, IZQUIERDA\n   Estado: Disponible\n\n4. Introducción al psicoanálisis para educadores de Anna Freud\n   Ubicación: E1, B - ESTE, FILA 3, IZQUIERDA\n   Estado: Disponible\n\n5. Tomo I: De la antigüedad a comienzos del siglo XIX de \n   Ubicación: E1, B - ESTE, FILA 1, IZQUIERDA\n   Estado: Disponible\n\n', 0.000, '2025-06-20 19:48:43'),
(542, 'mas como esos', 'Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?', 0.000, '2025-06-20 19:49:09'),
(543, 'mas libros como antologia del psicoanalisis', 'Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?', 0.000, '2025-06-20 19:49:30');
INSERT INTO `chatbot_logs` (`id`, `mensaje`, `respuesta`, `tiempo_respuesta`, `fecha_hora`) VALUES
(544, 'de que trata Antropologia filosofica', ' El libro \"Antropología Filosófica\" de Bernhard Groethuysen examina la modernidad y la crisis del sujeto, explorando temas como humanismo, progreso y la historia, desde el punto de vista de la crisis que aflora en la actualidad. El autor analiza las características principales de la modernidad, como su ruptura con la tradición, su autonomía y su estado permanente de crisis, que originan una dinámica manifestada por la crisis del sujeto. Además, se intenta comprender el sujeto a partir de la crisis en que desemboca la modernidad, específicamente el nihilismo y la muerte de Dios.', 0.000, '2025-06-20 20:06:46'),
(545, 'quiero un libro sobre historia', ' Tengo un libro disponible sobre historia: Introducción a la filosofía de la historia de Raymond Aron. Esta obra se encuentra en la ubicación E1, B - ESTE, FILA 2, DERECHA en estado de disponibilidad.', 0.000, '2025-07-07 18:12:33'),
(546, 'tienes de poemas', ' Sí, tengo un libro relevante sobre el tema del poeta y la estética moderna: \"Poética : la imaginación del poeta, las tres épocas de la estética moderna y su problema actual\" de Wilhelm Dilthey. Este libro está disponible en nuestra biblioteca (Ubicación: E1, B - ESTE, FILA 2, IZQUIERDA, Estado: Disponible). Espero que sea de ayuda para tus estudios.', 0.000, '2025-07-07 18:13:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `direccion` text NOT NULL,
  `correo` varchar(100) NOT NULL,
  `foto` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id`, `nombre`, `telefono`, `direccion`, `correo`, `foto`) VALUES
(1, 'CMFB Arequipa', '925491523', 'Arequipa - Perú', 'cmfb@edu.pe', 'logo.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_permisos`
--

CREATE TABLE `detalle_permisos` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_permiso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_permisos`
--

INSERT INTO `detalle_permisos` (`id`, `id_usuario`, `id_permiso`) VALUES
(5, 2, 1),
(6, 2, 2),
(7, 2, 3),
(8, 2, 5),
(9, 2, 8),
(11, 3, 3),
(12, 3, 9),
(13, 3, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE `estudiante` (
  `id` int(11) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `año` varchar(255) NOT NULL,
  `direccion` text NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`id`, `codigo`, `dni`, `nombre`, `año`, `direccion`, `telefono`, `estado`) VALUES
(16, 'S001', '72839012', 'Juan Pérez Romero', '3', 'Av. Salaverry 120 - Cercado', '958374820', 1),
(17, 'S002', '73218456', 'Ana López Díaz', '4', 'Jr. Puno 450 - Miraflores', '914527839', 1),
(18, 'S003', '73459082', 'Carlos Soto Mejía', '5', 'Calle Arequipa 123 - Yanahuara', '923874560', 1),
(19, 'S004', '71234567', 'María Torres Quispe', '3', 'Av. Dolores 765 - José Luis Bustamante', '947102348', 1),
(20, 'S005', '75678934', 'José Ramírez Pinto', '4', 'Jr. Tacna 304 - Cercado', '988230145', 1),
(21, 'S006', '79832109', 'Luisa Chávez Ramos', '5', 'Calle Lima 100 - Cayma', '912458320', 1),
(22, 'S007', '72457983', 'Miguel Ríos Sánchez', '3', 'Av. Venezuela 230 - Paucarpata', '977654310', 1),
(23, 'S008', '73546210', 'Rosa Gómez Lazo', '4', 'Av. La Marina 678 - Cerro Colorado', '954731206', 1),
(24, 'S009', '70123498', 'Pedro Núñez Arias', '5', 'Calle Cusco 456 - Mariano Melgar', '984512307', 1),
(25, 'S010', '78345621', 'Claudia Medina Flores', '3', 'Av. Ejército 998 - Yanahuara', '936417823', 1),
(26, 'S011', '72938475', 'Sandra Cárdenas Ruiz', '4', 'Calle Bolívar 501 - Cercado', '962748201', 1),
(27, 'S012', '71594738', 'Jorge Gutiérrez León', '5', 'Av. Kennedy 389 - Alto Selva Alegre', '987456132', 1),
(28, 'S013', '75483920', 'Andrea Salas Vargas', '3', 'Av. La Pampilla 456 - Miraflores', '913248765', 1),
(29, 'S014', '76745238', 'Manuel Rodríguez López', '4', 'Calle Sucre 321 - Paucarpata', '955317620', 1),
(30, 'S015', '79283745', 'Valeria Silva Torres', '5', 'Jr. Misti 845 - Yanahuara', '918764320', 1),
(31, 'S016', '72348902', 'Luis Aguirre Neyra', '3', 'Av. Independencia 312 - Sachaca', '940257812', 1),
(32, 'S017', '73487910', 'Fiorella Delgado Cruz', '4', 'Calle Bolognesi 187 - Cercado', '916847390', 1),
(33, 'S018', '78592014', 'Sebastián Herrera Gálvez', '5', 'Av. Perú 678 - Socabaya', '902374812', 1),
(34, 'S019', '79475830', 'Brenda Huamán Chambi', '3', 'Calle Amazonas 200 - Hunter', '934178203', 1),
(35, 'S020', '70293847', 'Kevin Valdez Soto', '4', 'Av. Goyeneche 132 - José Luis Bustamante', '953681247', 1),
(36, 'S00177', '76543212', 'Mario Rodrigues', 'Tercero', 'Av Ejercito', '965743890', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `faqs`
--

CREATE TABLE `faqs` (
  `id` int(11) NOT NULL,
  `pregunta` varchar(255) NOT NULL,
  `respuesta` text NOT NULL,
  `patron_regex` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `faqs`
--

INSERT INTO `faqs` (`id`, `pregunta`, `respuesta`, `patron_regex`) VALUES
(2, 'donde estan los libros nuevos?', 'estan en el estante mas alejado por la puerta al fondo de la biblioteca', '¿?d(ó|o)nde\\s+est(á|a)n\\s+(los\\s+)?libros\\s+nuevos\\??');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro`
--

CREATE TABLE `libro` (
  `id` int(11) NOT NULL,
  `titulo` text NOT NULL,
  `autor_personal` varchar(100) DEFAULT NULL,
  `autor_corporativo` varchar(100) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `editorial` varchar(150) NOT NULL,
  `anio_edicion` date NOT NULL,
  `num_pagina` int(11) NOT NULL,
  `codigo_dewey` varchar(50) NOT NULL,
  `codigo_libro` varchar(50) NOT NULL,
  `ubicacion` varchar(100) NOT NULL,
  `lugar` varchar(100) DEFAULT NULL,
  `descripcion` text NOT NULL,
  `imagen` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1,
  `materia` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libro`
--

INSERT INTO `libro` (`id`, `titulo`, `autor_personal`, `autor_corporativo`, `cantidad`, `editorial`, `anio_edicion`, `num_pagina`, `codigo_dewey`, `codigo_libro`, `ubicacion`, `lugar`, `descripcion`, `imagen`, `estado`, `materia`) VALUES
(968, 'Enciclopedia Universal Ilustrada Tomo I (A-ACD)', '', 'Espasa Calpe', 0, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00715', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(969, 'Enciclopedia Universal Ilustrada Tomo II (ACE-ADZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00716', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(970, 'Enciclopedia Universal Ilustrada Tomo III (AE-ALAK)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00717', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(971, 'Enciclopedia Universal Ilustrada Tomo IV (ALAL-ALLY)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00718', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(972, 'Enciclopedia Universal Ilustrada Tomo V (AM-ARCH)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00719', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(973, 'Enciclopedia Universal Ilustrada Tomo VI (ARD-AZZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00720', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(974, 'Enciclopedia Universal Ilustrada Tomo VII (B-BELL)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00721', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(975, 'Enciclopedia Universal Ilustrada Tomo VIII (BEM-BONF)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00722', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(976, 'Enciclopedia Universal Ilustrada Tomo IX (BONG-BZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00723', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(977, 'Enciclopedia Universal Ilustrada Tomo X (C-CANAJ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00724', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(978, 'Enciclopedia Universal Ilustrada Tomo XI (CANAL-CARZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00725', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(979, 'Enciclopedia Universal Ilustrada Tomo XII (CAS-CG)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00726', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(980, 'Enciclopedia Universal Ilustrada Tomo XIII (CI-COLD)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00727', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(981, 'Enciclopedia Universal Ilustrada Tomo XIV (COLE-CONST)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00728', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(982, 'Enciclopedia Universal Ilustrada Tomo XV (CONST-CRAZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00729', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(983, 'Enciclopedia Universal Ilustrada Tomo XVI (CRE-CHARG)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00730', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(984, 'Enciclopedia Universal Ilustrada Tomo XVII (CHARI-DELLW)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00731', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(985, 'Enciclopedia Universal Ilustrada Tomo XVIII Parte 1 (DEM-DIR)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00732', 'E1, A - OESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(986, 'Enciclopedia Universal Ilustrada Tomo XVIII Parte 2 (DIS-ECZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00733', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(987, 'Enciclopedia Universal Ilustrada Tomo XIX (ECH-ENRE)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00734', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(988, 'Enciclopedia Universal Ilustrada Tomo XX (ENRI-ESPAN)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00735', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(989, 'Enciclopedia Universal Ilustrada Tomo XXI (ESPANA)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00736', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(990, 'Enciclopedia Universal Ilustrada Tomo XXII (ESPANA-EZZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00737', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(991, 'Enciclopedia Universal Ilustrada Tomo XXIII (F-FLAMEZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00738', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(992, 'Enciclopedia Universal Ilustrada Tomo XXIV (FLAMI-FUH)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00739', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(993, 'Enciclopedia Universal Ilustrada Tomo XXV (FUI-GIBZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00740', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(994, 'Enciclopedia Universal Ilustrada Tomo XXVI (GIC-GUAZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00741', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(995, 'Enciclopedia Universal Ilustrada Tomo XXVII (GUB-HN)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00742', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(996, 'Enciclopedia Universal Ilustrada Tomo XXVIII Parte 1 (HO-INSUS)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00743', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(997, 'Enciclopedia Universal Ilustrada Tomo XXVIII Parte 2 (INT-KZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00744', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(998, 'Enciclopedia Universal Ilustrada Tomo XXX (LEONA-LOMZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00745', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(999, 'Enciclopedia Universal Ilustrada Tomo XXXI (LON-MADZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00746', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1000, 'Enciclopedia Universal Ilustrada Tomo XXXII (MAE-MARH)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00747', 'E1, A - OESTE, FILA 1, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1001, 'Enciclopedia Universal Ilustrada Tomo XXXIII (MARI-MECH)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00748', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1002, 'Enciclopedia Universal Ilustrada Tomo XXXIV (MED-MICZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00749', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1003, 'Enciclopedia Universal Ilustrada Tomo XXXV (MICH-MOMZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00750', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1004, 'Enciclopedia Universal Ilustrada Tomo XXXVI (MON-MTZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00751', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1005, 'Enciclopedia Universal Ilustrada Tomo XXXVII (MU-NEBY)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00752', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1006, 'Enciclopedia Universal Ilustrada Tomo XXXVIII (NEC-NULLY)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00753', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1007, 'Enciclopedia Universal Ilustrada Tomo XXXIX (NUM-OQU)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00754', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1008, 'Enciclopedia Universal Ilustrada Tomo XL (OR-PAKU)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00755', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1009, 'Enciclopedia Universal Ilustrada Tomo XLI (PAL-PAROZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00756', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1010, 'Enciclopedia Universal Ilustrada Tomo XLII (PARE-PEKZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00757', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1011, 'Enciclopedia Universal Ilustrada Tomo XLIII (PEL-PESZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00758', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1012, 'Enciclopedia Universal Ilustrada Tomo XLIV (PET-PIRZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00759', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1013, 'Enciclopedia Universal Ilustrada Tomo XLV (PIS-POLN)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00760', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1014, 'Enciclopedia Universal Ilustrada Tomo XLVI (POLO-PREDZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00761', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1015, 'Enciclopedia Universal Ilustrada Tomo XLVII (PREE-PTZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00762', 'E1, A - OESTE, FILA 2, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1016, 'Enciclopedia Universal Ilustrada Tomo XLVIII (PU-QW)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00763', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1017, 'Enciclopedia Universal Ilustrada Tomo XLIX (R-REEZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00764', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1018, 'Enciclopedia Universal Ilustrada Tomo L (REF-REUZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00765', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1019, 'Enciclopedia Universal Ilustrada Tomo LI (REV-ROM)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00766', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1020, 'Enciclopedia Universal Ilustrada Tomo LII (ROMA-SAINT)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00767', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1021, 'Enciclopedia Universal Ilustrada Tomo LIII (SAINTE-StaCRUZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00768', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1022, 'Enciclopedia Universal Ilustrada Tomo LIV (StaCUBICIA-SELH)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00769', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1023, 'Enciclopedia Universal Ilustrada Tomo LV (SELI-SIEZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00770', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1024, 'Enciclopedia Universal Ilustrada Tomo LVI (SIF-SOL)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00771', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1025, 'Enciclopedia Universal Ilustrada Tomo LVII (SOLA-SUBN)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00772', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1026, 'Enciclopedia Universal Ilustrada Tomo LVIII (SUBO-TALASZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00773', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1027, 'Enciclopedia Universal Ilustrada Tomo LIX (TALAT-TELD)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00774', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1028, 'Enciclopedia Universal Ilustrada Tomo LX (TELE-TERZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00775', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1029, 'Enciclopedia Universal Ilustrada Tomo LXI (TES-TIRN)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00776', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1030, 'Enciclopedia Universal Ilustrada Tomo LXII (TIRO-TOUM)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00777', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1031, 'Enciclopedia Universal Ilustrada Tomo LXIII (TOUN-TRAZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00778', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1032, 'Enciclopedia Universal Ilustrada Tomo LXIV (TOUN-TRAZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00779', 'E1, A - OESTE, FILA 2, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1033, 'Enciclopedia Universal Ilustrada Tomo LXIV (TRE-TUMZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00780', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1034, 'Enciclopedia Universal Ilustrada Tomo LXV (TUN-URZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00781', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1035, 'Enciclopedia Universal Ilustrada Tomo LXVI (U.S.-VAREZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00782', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1036, 'Enciclopedia Universal Ilustrada Tomo LXVII (VARF-VERQ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00783', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1037, 'Enciclopedia Universal Ilustrada Tomo LXVIII (VERR-VINIE)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00784', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1038, 'Enciclopedia Universal Ilustrada Tomo LXIX (VINIF-WEF)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00785', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1039, 'Enciclopedia Universal Ilustrada Tomo LXX (WEG-ZZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00786', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1040, 'Enciclopedia Universal Ilustrada Apéndice I (A-BECH)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00787', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1041, 'Enciclopedia Universal Ilustrada Apéndice II (BED-CEO)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00788', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1042, 'Enciclopedia Universal Ilustrada Apéndice III (CER-DEM)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00789', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1043, 'Enciclopedia Universal Ilustrada Apéndice IV (DEN-EZT)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00790', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1044, 'Enciclopedia Universal Ilustrada Apéndice V (F-HOK)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00791', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1045, 'Enciclopedia Universal Ilustrada Apéndice VI (HOL-MARCH)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00792', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1046, 'Enciclopedia Universal Ilustrada Apéndice VII (MARD-OZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00793', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1047, 'Enciclopedia Universal Ilustrada Apéndice VIII (P-REE)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00794', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1048, 'Enciclopedia Universal Ilustrada Apéndice IX (REF-SZ)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00795', 'E1, A - OESTE, FILA 3, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1049, 'Enciclopedia Universal Ilustrada Apéndice X (T-ZYX)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00796', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1050, 'Enciclopedia Universal Ilustrada Suplemento I - 1934', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00797', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1051, 'Enciclopedia Universal Ilustrada Suplemento II - 1935', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00798', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1052, 'Enciclopedia Universal Ilustrada Suplemento III - 1936-39 (1ª Parte)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00799', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1053, 'Enciclopedia Universal Ilustrada Suplemento III - 1936-39 (2ª Parte)', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00800', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1054, 'Enciclopedia Universal Ilustrada Suplemento IV - 1940-41', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00801', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1055, 'Enciclopedia Universal Ilustrada Suplemento V - 1942-44', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00802', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1056, 'Enciclopedia Universal Ilustrada Suplemento VI - 1945-48', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00803', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1057, 'Enciclopedia Universal Ilustrada Suplemento VII - 1949-52', '', 'Espasa Calpe', 1, 'Espasa Calpe', '1949-01-01', 0, '036.T1', '00804', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1058, 'Enciclopedia Autodidactica Oceano Vol. 1', '', 'Europeo Americana', 1, 'Espasa Calpe', '1986-01-01', 0, '036.E55', '99', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1059, 'Enciclopedia Autodidactica Oceano Vol. 2', '', 'Europeo Americana', 1, 'Espasa Calpe', '1986-01-01', 0, '036.E55', '100', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1060, 'Enciclopedia Autodidactica Oceano Vol. 3', '', 'Europeo Americana', 1, 'Espasa Calpe', '1986-01-01', 0, '036.E55', '101', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1061, 'Enciclopedia Autodidactica Oceano Vol. 4', '', 'Europeo Americana', 1, 'Espasa Calpe', '1986-01-01', 0, '036.E55', '102', 'E1, A - OESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1062, 'Enciclopedia Barsa T. 1: Índice enciclopédico', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '103', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1063, 'Enciclopedia Barsa T. 2: .Aaron - Armadi.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '104', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1064, 'Enciclopedia Barsa T. 3: Armadu - Bolsa.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '105', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1065, 'Enciclopedia Barsa T. 4: Bomba - Cinem.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '106', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1066, 'Enciclopedia Barsa T. 5: Cinic - Diente.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '107', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1067, 'Enciclopedia Barsa T. 6: Dientes - Famil.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '108', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1068, 'Enciclopedia Barsa T. 7: Fanfa - Guayac.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '109', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1069, 'Enciclopedia Barsa T. 8: Guayan - Ingla.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '110', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1070, 'Enciclopedia Barsa T. 9: Ingle - Lond.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '111', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1071, 'Enciclopedia Barsa T. 10: Long - Muerd.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '112', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1072, 'Enciclopedia Barsa T. 11: Muert - Pericl.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '113', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1073, 'Enciclopedia Barsa T. 12: Perico - Rami.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '114', 'E1, A - OESTE, FILA 3, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1074, 'Enciclopedia Barsa T. 13: Ramo - Sola.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '115', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1075, 'Enciclopedia Barsa T. 14: Sold - Urug.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '116', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1076, 'Enciclopedia Barsa T. 15: Usuf - Zweig | Atlas.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '117', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1077, 'Enciclopedia Barsa T. 16: Guías de lectura.', '', 'Enciclopedia Barsa', 1, 'Enciclopedia Barsa', '1973-01-01', 0, '036', '118', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1078, 'Nueva Enciclopedia Temática T. 1: Geología, Astronomía, Física, Conquista del Espacio.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '119', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1079, 'Nueva Enciclopedia Temática T. 2: Química, La vida botánica y Vida en el Mar.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '120', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1080, 'Nueva Enciclopedia Temática T. 4: Mamíferos y El hombre.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '121', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1081, 'Nueva Enciclopedia Temática T. 5: Campo, construcción, Metales y construcción.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '122', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1082, 'Nueva Enciclopedia Temática T. 6: Oficios, Comunicación y Transporte.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '123', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1083, 'Nueva Enciclopedia Temática T. 7: Ciencias, Tecnología, Electricidad, Electrónica y Guía Materna.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '124', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1084, 'Nueva Enciclopedia Temática T. 8: Prehistoria y Historia Antigua.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '125', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1085, 'Nueva Enciclopedia Temática T. 9: Edad Media y Europa.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '126', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1086, 'Nueva Enciclopedia Temática T. 10: Europa y Rusia.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '127', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1087, 'Nueva Enciclopedia Temática T. 11: América del Norte, Asia y África.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '128', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1088, 'Nueva Enciclopedia Temática T. 12: España, Portugal y América Latina.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '129', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1089, 'Nueva Enciclopedia Temática T. 14: Índice Alfabético.', '', 'Enciclopedia Tematica', 1, 'Richards', '1963-01-01', 0, '036', '130', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Panama', '', ' ', 1, 'Generalidades'),
(1090, 'Enciclopedia autodidáctica Quillet Tomo I: guia de enseñanza moderna y práctica, publicada con la colaboración de un comité de catedráticos y profesores', '', 'Quillet', 1, 'Quillet', '1939-01-01', 0, '030.E', '131', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1091, 'Enciclopedia autodidáctica Quillet Tomo II : guia de enseñanza moderna y práctica, publicada con la colaboración de un comité de catedráticos y profesores', '', 'Quillet', 1, 'Quillet', '1939-01-01', 0, '030.E', '132', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1092, 'Enciclopedia autodidáctica Quillet Tomo III: guia de enseñanza moderna y práctica, publicada con la colaboración de un comité de catedráticos y profesores', '', 'Quillet', 1, 'Quillet', '1939-01-01', 0, '030.E', '133', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1093, 'Nueva enciclopedia autodidáctica Quillet Tomo I', '', 'Quillet', 1, 'Quillet', '1968-01-01', 0, '034.E', '134', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1094, 'Nueva enciclopedia autodidáctica Quillet Tomo II', '', 'Quillet', 1, 'Quillet', '1968-01-01', 0, '034.E', '135', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1095, 'Nueva enciclopedia autodidáctica Quillet Tomo III', '', 'Quillet', 1, 'Quillet', '1968-01-01', 0, '034.E', '136', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1096, 'Nueva enciclopedia autodidáctica Quillet Tomo IV', '', 'Quillet', 1, 'Quillet', '1968-01-01', 0, '034.E', '137', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1097, 'Enciclopedia clásica de mitología, religión, biografías, literatura, arte y antigüedades', 'Oskar Seyffert, José. Goñi Urriza', '', 1, 'El Ateneo', '1947-01-01', 0, '030.S4', '138', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1098, 'ENCICLOPEDIA GENERAL BASICA VISUAL OCEANO. TOMO 2. Catacumbas/Federico II.', '', 'Espasa Calpe', 1, 'Careos Gisper', '1986-01-01', 0, '036.E', '140', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1099, 'ENCICLOPEDIA GENERAL BASICA VISUAL OCEANO. TOMO 3. Félidos/Mano.', '', 'Espasa Calpe', 1, 'Careos Gisper', '1986-01-01', 0, '036.E', '141', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1100, 'ENCICLOPEDIA GENERAL BASICA VISUAL OCEANO. TOMO 4. Mao/Puccini.', '', 'Espasa Calpe', 1, 'Careos Gisper', '1986-01-01', 0, '036.E', '142', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1101, 'ENCICLOPEDIA GENERAL BASICA VISUAL OCEANO. TOMO 5. Puente/Zorro/Indices.', '', 'Espasa Calpe', 1, 'Careos Gisper', '1986-01-01', 0, '036.E', '143', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1102, 'Diccionario enciclopédico Quillet: A - Azzano (Tomo I)', '', 'Aristides Quillet', 1, 'A. Aristides', '1971-01-01', 0, '036.E', '144', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1103, 'Diccionario enciclopédico Quillet: B - Compraventa (Tomo II)', '', 'Aristides Quillet', 1, 'A. Aristides', '1971-01-01', 0, '036.E', '145', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1104, 'Diccionario enciclopédico Quillet: Comprender - Estucurú (Tomo III)', '', 'Aristides Quillet', 1, 'A. Aristides', '1971-01-01', 0, '036.E', '146', 'E1, A - OESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1105, 'Diccionario enciclopédico Quillet: Estuche - Historia (Tomo IV)', '', 'Aristides Quillet', 0, 'A. Aristides', '1971-01-01', 0, '036.E', '147', 'E1, A - OESTE, FILA 4, DERECHA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1106, 'Diccionario enciclopédico Quillet: Historiado - Mamífero (Tomo V)', '', 'Aristides Quillet', 1, 'A. Aristides', '1971-01-01', 0, '036.E', '148', 'E1, A - OESTE, FILA 4, DERECHA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1107, 'Diccionario enciclopédico Quillet: Mamila - Patelar (Tomo VI)', '', 'Aristides Quillet', 1, 'A. Aristides', '1971-01-01', 0, '036.E', '149', 'E1, A - OESTE, FILA 4, DERECHA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1108, 'Diccionario enciclopédico Quillet: Patélidos - Scheele (Tomo VII)', '', 'Aristides Quillet', 1, 'A. Aristides', '1971-01-01', 0, '036.E', '150', 'E1, A - OESTE, FILA 4, DERECHA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1109, 'Diccionario enciclopédico Quillet: Scheer - Zywiec (Tomo VIII)', '', 'Aristides Quillet', 1, 'A. Aristides', '1971-01-01', 0, '036.E', '151', 'E1, A - OESTE, FILA 4, DERECHA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1110, 'Enciclopedia El Ateneo I: El Universo, la Tierra y sus riquezas (Parte 1)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '152', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1111, 'Enciclopedia El Ateneo I: El Universo, la Tierra y sus riquezas (Parte 2)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '153', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1112, 'Enciclopedia El Ateneo II: El Hombre, su historia y sus creencias (Parte 1)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '154', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1113, 'Enciclopedia El Ateneo II: El Hombre, su historia y sus creencias (Parte 2)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '155', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1114, 'Enciclopedia El Ateneo III: El Pensamiento y el mundo de las letras (Parte 1)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '156', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1115, 'Enciclopedia El Ateneo III: El Pensamiento y el mundo de las letras (Parte 2)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '157', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1116, 'Enciclopedia El Ateneo IV: Arte, música y espectáculos (Parte 1)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '158', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1117, 'Enciclopedia El Ateneo IV: Arte, música y espectáculos (Parte 2)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '159', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1118, 'Enciclopedia El Ateneo V: El Mundo de la ciencia (Parte 1)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '160', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1119, 'Enciclopedia El Ateneo V: El Mundo de la ciencia (Parte 2)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '161', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1120, 'Enciclopedia El Ateneo VI: El Hombre, constructor de su mundo (Parte 1)', '', 'El Ateneo', 1, 'El Ateneo Ediciones', '1965-01-01', 0, '030.E', '162', 'E1, A - OESTE, FILA 4, DERECHA', 'Argentina', '', ' ', 1, 'Generalidades'),
(1121, 'Panorama, colección de enciclopedias monográficas Tomo 7 - El Juego y los Deportes', '', 'Encoclopedias Monograficas', 1, 'Nicola Zamichelli', '1966-01-01', 0, '030.E', '163', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1122, 'Panorama, colección de enciclopedias monográficas Tomo 8 - El Hombre y la Técnica', '', 'Encoclopedias Monograficas', 1, 'Nicola Zamichelli', '1966-01-01', 0, '030.E', '164', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1123, 'Panorama, colección de enciclopedias monográficas Tomo 6 - Ciencia e Investigación', '', 'Encoclopedias Monograficas', 1, 'Nicola Zamichelli', '1966-01-01', 0, '030.E', '165', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1124, 'Panorama, colección de enciclopedias monográficas Tomo 2 - La Tierra en que Vivimos', '', 'Encoclopedias Monograficas', 1, 'Nicola Zamichelli', '1966-01-01', 0, '030.E', '166', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1125, 'Panorama, colección de enciclopedias monográficas Tomo 3 - Las Leyes de la Vida', '', 'Encoclopedias Monograficas', 1, 'Nicola Zamichelli', '1966-01-01', 0, '030.E', '167', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1126, 'Panorama, colección de enciclopedias monográficas Tomo 4 - El Arte en la Cultura', '', 'Encoclopedias Monograficas', 1, 'Nicola Zamichelli', '1966-01-01', 0, '030.E', '168', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1127, 'Panorama, colección de enciclopedias monográficas Tomo 1 - Libros en el Tiempo', '', 'Encoclopedias Monograficas', 1, 'Nicola Zamichelli', '1966-01-01', 0, '030.E', '169', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1128, 'Enciclopedia concisa Sopena : Diccionario ilustrado de la lengua española Tomo I', '', 'Enciclopedia Concisa', 1, 'Ramon Sopema', '1985-01-01', 0, '030.E', '170', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1129, 'Enciclopedia concisa Sopena : Diccionario ilustrado de la lengua española Tomo II', '', 'Enciclopedia Concisa', 1, 'Ramon Sopema', '1985-01-01', 0, '030.E', '171', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1130, 'Enciclopedia concisa Sopena : Diccionario ilustrado de la lengua española Tomo III', '', 'Enciclopedia Concisa', 1, 'Ramon Sopema', '1985-01-01', 0, '030.E', '172', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1131, 'Enciclopedia concisa Sopena : Diccionario ilustrado de la lengua española Tomo IV', '', 'Enciclopedia Concisa', 1, 'Ramon Sopema', '1985-01-01', 0, '030.E', '173', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1132, 'Enciclopedia de Iniciacion Cultural Tomo 1', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '174', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1133, 'Enciclopedia de Iniciacion Cultural Tomo 2', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '175', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1134, 'Enciclopedia de Iniciacion Cultural Tomo 3', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '176', 'E1, A - OESTE, FILA 4, DERECHA', 'España', '', ' ', 1, 'Generalidades'),
(1135, 'Enciclopedia de Iniciacion Cultural Tomo 4', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '177', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1136, 'Enciclopedia de Iniciacion Cultural Tomo 5', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '178', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1137, 'Enciclopedia de Iniciacion Cultural Tomo 6', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '179', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1138, 'Enciclopedia de Iniciacion Cultural Tomo 7', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '180', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1139, 'Enciclopedia de Iniciacion Cultural Tomo 8', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '181', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1140, 'Enciclopedia de Iniciacion Cultural Tomo 9', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '182', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1141, 'Enciclopedia de Iniciacion Cultural Tomo 10', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '183', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1142, 'Enciclopedia de Iniciacion Cultural Tomo 11', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '184', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1143, 'Enciclopedia de Iniciacion Cultural Tomo 12', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '185', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1144, 'Enciclopedia de Iniciacion Cultural Tomo 13', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '186', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1145, 'Enciclopedia de Iniciacion Cultural Tomo 14', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '187', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1146, 'Enciclopedia de Iniciacion Cultural Tomo 15', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '188', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1147, 'Enciclopedia de Iniciacion Cultural Tomo 16', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '189', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1148, 'Enciclopedia de Iniciacion Cultural Tomo 17', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '190', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1149, 'Enciclopedia de Iniciacion Cultural Tomo 18', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '191', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1150, 'Enciclopedia de Iniciacion Cultural Tomo 19', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '192', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1151, 'Enciclopedia de Iniciacion Cultural Tomo 21', '', 'Enciclopedia de Iniciacion Cultural', 1, 'Salvat S.A', '1943-01-01', 0, '030 2', '193', 'E1, A - OESTE, FILA 5, IZQUIERDA', 'España', '', ' ', 1, 'Generalidades'),
(1152, 'Tomo I: De la antigüedad a comienzos del siglo XIX', '', 'Grijalbo', 1, 'Grijalbo', '1957-01-01', 0, '100.D99', '194', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1153, 'Tomo II: De la Revolución Burguesa de Francia de 1789 al nacimiento del marxismo', '', 'Grijalbo', 1, 'Grijalbo', '1957-01-01', 0, '100.D99', '195', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1154, 'Tomo III: Desde el nacimiento del marxismo hasta finales del siglo XIX', '', 'Grijalbo', 1, 'Grijalbo', '1957-01-01', 0, '100.D99', '196', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1155, 'Tomo IV: Segunda mitad del siglo XIX', '', 'Grijalbo', 1, 'Grijalbo', '1957-01-01', 0, '100.D99', '197', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1156, 'Tomo V: Desde finales del siglo XIX hasta la Revolución Socialista de octubre de 1917', '', 'Grijalbo', 1, 'Grijalbo', '1957-01-01', 0, '100.D99', '198', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1157, 'Tomo VI: Desde la Revolución Socialista de octubre de 1917 hasta nuestros días', '', 'Grijalbo', 1, 'Grijalbo', '1957-01-01', 0, '100.D99', '199', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1158, 'Tomo VII: Desde la Revolución Socialista de octubre de 1917 hasta nuestros días', '', 'Grijalbo', 1, 'Grijalbo', '1957-01-01', 0, '100.D99', '200', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1159, 'Qué es la filosofía', 'Francisco Romero', '', 1, 'Columba', '1953-01-01', 0, '100', '202', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires,', '', ' ', 1, 'Filosofía y Psicología'),
(1160, 'Filosofía de la historia para la educación de la humanidad', 'Johann Gottfried Herder, Eugenio Pucciarelli', '', 1, 'Nova', '1950-01-01', 0, '901.H41', '203', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires,', '', ' ', 1, 'Historia y Geografía'),
(1161, 'Historia de la filosofía : La filosofía griega 1', 'Walter Kranz', '', 1, 'UTEHA', '1962-01-01', 0, '180.K79', '204', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1162, 'Problemas fundamentales de la filosofía', 'Georg Simmel, Héctor Rogel', '', 1, 'UTEHA', '1961-01-01', 0, '182.S56', '205', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1163, 'Antropologiá filosófica : autointerpretación del hombre en la historia y en el presente', 'Michael Landmann', '', 1, 'UTEHA', '1961-01-01', 0, '100.L3', '206', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1164, 'Historia de la filosofía : La filosofía griega 3', 'Walter Kranz', '', 1, 'UTEHA', '1964-01-01', 0, '180.K79', '207', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1165, 'Los moralistas modernos', 'Elèmire Zolla', '', 1, 'UTEHA', '1962-01-01', 0, '082.Z85', '208', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Generalidades'),
(1166, 'Historia de la filosofía : La filosofía griega 2', 'Walter Kranz', '', 1, 'UTEHA', '1964-01-01', 0, '180.K79', '210', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1167, 'Logica Metodologia y Etica 5 año de sec.', 'Peñaloza Walter', '', 2, 'CMLP', '1951-01-01', 0, '160.P4', '212;213', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Peru', '', ' ', 1, 'Filosofía y Psicología'),
(1168, 'Logica Contemporanea', 'R. Blanche', '', 1, 'Carlos Lohele', '1963-01-01', 0, 'B.61', '214', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Argentina', '', ' ', 1, '#VALUE!'),
(1169, 'Lógica', 'Immanuel Kant, Alejo García Moreno, Juan Rovira', '', 1, 'Tor', '1900-01-01', 0, '123.2.K21', '215', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires,', '', ' ', 1, 'Filosofía y Psicología'),
(1170, 'Introduccion a la Filosofia', 'Julian Marias', '', 1, 'Castilla', '1963-01-01', 0, '129.63.M26', '217', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'España', '', ' ', 1, 'Filosofía y Psicología'),
(1171, 'Logica', 'Wesley C. Salmon, Carlos Gerhard', '', 1, 'UTEHA', '1965-01-01', 0, '160.S17', '219', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1172, 'Breve antología filosófica', 'Augusto Salazar Bondy', '', 1, 'Universo', '1967-01-01', 0, '100.S3', '220', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1173, 'Crítica religiosa', 'Voltaire, Pedro Seguí', '', 1, 'Grijalbo', '1971-01-01', 0, '142.V6', '221', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1174, 'Principios de lógica', 'Eli de Gortari, D. P. Gorski, P. V. Tavants', '', 1, 'Grijalbo', '1971-01-01', 0, '160.G74', '222', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1175, '7 ensayos filosoficos sobre la ciencia moderna', 'Omas R. Hofmann ; tr de Ma de Lourdes Fournier ; rev de Gerardo Quiroz Vieyra Gortari', '', 1, 'Grijalbo', '1973-01-01', 0, '190.G74', '223', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1176, 'Acerca del estado', 'Vladimir Il\'ich Lenin', '', 1, 'Grijalbo', '1975-01-01', 0, '323.L4', '224', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Ciencias Sociales'),
(1177, 'Una cultura moribunda : la cultura burguesa', 'Christopher Caudwell, Vicente Romano', '', 1, 'Grijalbo', '1970-01-01', 0, '190.C3', '225', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1178, 'Inhibición, síntoma y angustia', 'Sigmund Freud, L. López Ballesteros', '', 1, 'Grijalbo', '1970-01-01', 0, '157.F74', '226', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1179, 'El derecho de las naciones a la autodeterminación', 'Vladimir Il\'ich Lenin, Alejandro González', '', 1, 'Grijalbo', '1969-01-01', 0, '335.L4', '227', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Ciencias Sociales'),
(1180, 'Crítica de la filosofía del estado de Hegel', 'Carlos Marx', '', 1, 'Grijalbo', '1968-01-01', 0, '142.M3', '230', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1181, 'La libertad en el arte', 'Honor Arundel', '', 1, 'Grijalbo', '1967-01-01', 0, '323.A7', '232', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Ciencias Sociales'),
(1182, 'La gran Revolución Socialista de octubre', 'G. N. Golikov', '', 1, 'Grijalbo', '1970-01-01', 0, '335.G6', '234', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Ciencias Sociales'),
(1183, 'El Colonialismo', 'Carlos Marx', '', 0, 'Grijalbo', '1970-01-01', 0, '325.3.M26', '235', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Ciencias Sociales'),
(1184, 'Darwin y el darvinismo', 'Marcel Prenant', '', 1, 'Grijalbo', '1969-01-01', 0, '576.0162.P85', '236', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Ciencias Puras'),
(1185, 'Revolución en filosofía', 'Howard Selsam, Raúl M. Viladot', '', 1, 'Grijalbo', '1968-01-01', 0, '100.S37', '237', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1186, 'El mecanismo de la vida', 'Alejandro Popovsky', '', 1, 'Grijalbo', '1968-01-01', 0, '574.P6', '238', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Ciencias Puras'),
(1187, 'El capital visto por su autor', 'Karl Marx, Friedrich Engels', '', 1, 'Grijalbo', '1974-01-01', 0, '190.M3', '240', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1188, 'Escritos filosóficos y políticos', 'Donatien Alphonse François Sade, Alfredo Juan Alvarez', '', 1, 'Grijalbo', '1969-01-01', 0, '190.M3', '241', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'México', '', ' ', 1, 'Filosofía y Psicología'),
(1189, 'Filosofía, cultura y vida', 'Will Durant', '', 1, 'Sudamericana', '1960-01-01', 0, '100.098.W', '246', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires,', '', ' ', 1, 'Filosofía y Psicología'),
(1190, 'El Hombre mediocre', 'José Ingenieros, Aníbal Ponce', '', 1, 'Tor', '1955-01-01', 0, '137.I53', '249;253', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires,', '', ' ', 1, 'Filosofía y Psicología'),
(1191, '¿Qué es la filosofía? o de una sabiduría heróica', 'Angel Vassallo', '', 1, 'Losada', '1945-01-01', 0, '104.V34', '254', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1192, 'Alrededor de la filosofía', 'Arthur Schopenhauer', '', 1, 'Tor', '1940-01-01', 0, '123.7.S29', '255', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1193, 'Breve vocabulario filosófico', 'Augusto Salazar Bondy', '', 1, 'Universo', '1967-01-01', 0, '103.S18', '256', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1194, 'Obras filosóficas', 'Denis Diderot', '', 1, 'Tor', '1920-01-01', 0, '124.5.D74', '259', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1195, 'Las grandes culturas y su filosofía comparada', 'Dolores Riesco Díaz', '', 1, 'Castilla', '1968-01-01', 0, '809.933.R56', '260', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Madrid', '', ' ', 1, 'Literatura');
INSERT INTO `libro` (`id`, `titulo`, `autor_personal`, `autor_corporativo`, `cantidad`, `editorial`, `anio_edicion`, `num_pagina`, `codigo_dewey`, `codigo_libro`, `ubicacion`, `lugar`, `descripcion`, `imagen`, `estado`, `materia`) VALUES
(1196, 'El valor de la persona humana', 'Giorgio La Pira, Raúl Gustavo Aguirre, Jorge L. García Venturini, Silvio Baldessari', '', 1, 'Troquel', '1964-01-01', 0, '156.P61', '261', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1197, 'Esencia y formas de la simpatía', 'Max Ferdinand Scheler, José Gaos', '', 1, 'Losada', '1957-01-01', 0, '152.4.S29', '263', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1198, 'Introducción a la Filosofía y Lógica', 'Walter Peñaloza R.', '', 1, 'Colegio Militar Leoncio Prado', '1965-01-01', 0, '100.P42', '264', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1199, 'Filosofia y Logica', 'Luis Adolfo Piscoya Hermoza', '', 1, 'Quipu', '1979-01-01', 0, '160.P62', '265', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1200, 'La filosofía, hoy : de los orígenes románticos hasta los problemas actuales ; tr. por Claudio Matons Rossi y Juan José Ruiz Cuevas', 'Michele Federico Sciacca', '', 1, 'Luis Miracle', '1956-01-01', 0, '120.S31', '267', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1201, 'Diccionario de filosofía', 'José Ferrater Mora', '', 1, 'Sudamericana', '1951-01-01', 0, '103.F43', '269', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1202, 'Vocabulario técnico y crítico de la Filosofía I.(De la A a la L)', 'Lalande, André', '', 1, 'El Ateneo', '1953-01-01', 0, '103.L19', '270', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1203, 'Vocabulario técnico y crítico de la filosofía II.(De la LL a la Z)', 'Lalande, André', '', 1, 'El Ateneo', '1953-01-01', 0, '103.L19', '271', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1204, 'La Medicina de las pasiones, ó, Las pasiones consideradas con respecto a las enfermedades, a las leyes y a la religión', 'Jean Baptiste Félix Descuret', '', 1, 'Impr. y Libr. de Pablo Riera', '1857-01-01', 0, '152.4.D61', '272', 'E1, B - ESTE, FILA 1, IZQUIERDA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1205, 'Del hombre á la ciencia filosofía del siglo XX', 'Félix Le Dantec, Rafael Urbano', '', 1, 'Lib. Gutenberg de José Ruiz', '1909-01-01', 0, '501.L33', '273', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Ciencias Puras'),
(1206, 'Introducción a la Filosofía y Lógica para el quinto año de instrucción media', 'Luis Guillermo Talavera T.', '', 1, 'Colegio Militar Leoncio Prado', '1960-01-01', 0, '100.160.T16', '276', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1207, 'Historia de la filosofía : desde el renacimiento hasta Kant', 'Kurt Schilling', '', 1, 'UTEHA', '1965-01-01', 0, '180.S29', '278', 'E1, B - ESTE, FILA 1, DERECHA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1208, 'Idea de la filosofía : el conocimiento', 'Jorge Millas', '', 1, 'Universitaria', '1970-01-01', 0, '100.M58', '280', 'E1, B - ESTE, FILA 1, DERECHA', 'Santiago', '', ' ', 1, 'Filosofía y Psicología'),
(1209, 'Las ideas filosóficas de Menéndez Pelayo', 'Adolfo Muñoz Alonso', '', 1, 'Rialp', '1956-01-01', 0, '100.M26', '281', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1210, 'Ensayos críticos sobre filosofía, ciencias y letras', 'Alejandro Korn', '', 1, 'Claridad', '1960-01-01', 0, '129.82.K76', '282', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1211, 'Fedon', 'Plató, Ángel Álvarez de Miranda, Patronato \"Marcelino Ménéndez Pelayo\"', '', 1, 'Instituto Antonio de Nebrija', '1959-01-01', 0, '184.A49', '283', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1212, 'Idea de la metafiśica', 'Julián Marías', '', 1, 'Editorial Columba', '1954-01-01', 0, '110.M26', '287', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1213, 'Intuición de la vida : cuatro capítulos de metafísica', 'Georg Simmel', '', 1, 'Nova', '1950-01-01', 0, '143.S56', '290', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1214, 'Los principios de la filosofía', 'René Descartes', '', 1, 'Losada', '1951-01-01', 0, '100.D61', '291', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1215, 'Elementos de lógica : de acuerdo con los programas oficiales de la Secretaría de Educación para la enseñanza secundaria y preparatoria', 'Ismael Diego Pérez', '', 1, 'Herrero', '1958-01-01', 0, '160.P44', '292', 'E1, B - ESTE, FILA 1, DERECHA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1216, 'Problemas de filosofía de la historia ; seguido de los estudios El tiempo histórico ; La configuración histórica', 'Georg Simmel', '', 1, 'Nova', '1950-01-01', 0, '100.S56', '293', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1217, 'El espíritu de la filosofía moderna', 'Royce Josiah, Vicente P. Quintero', '', 1, 'Nova', '1947-01-01', 0, '120.R88', '295', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1218, 'La evolucíon del pensamiento kantiano : historia de una doctriana', 'Herman Jean dé Vleeshcauwer, Ricardo Guerra', '', 1, 'Centro de Estudios Filosóficos, Universidad Nacional Autónoma de México', '1962-01-01', 0, '153.42.V79', '296', 'E1, B - ESTE, FILA 1, DERECHA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1219, 'Lógica y nociones de teoría del conocimiento : manual adaptado a los programas de enseñanza vigentes', 'Francisco Romero, Eugenio Pucciarelli', '', 1, 'Espasa-Calpe Argentina', '1950-01-01', 0, '160.782.R81', '297', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1220, 'Las grandes corrientes del pensamiento contemporáneo. 2, Panoramas nacionales', 'Michele Federico Sciacca', '', 1, 'Guadarrama', '1959-01-01', 0, '153.42.S31', '298', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1221, 'Introduccion a la Filosofia y Logica', 'Antonio Pinilla', '', 1, 'Universo', '1960-01-01', 0, '106.P59', '300', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1222, 'Prolegómenos', 'Prolegómenos', '', 1, 'Sarpe', '1984-01-01', 0, '197.K21', '301', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1223, 'El banquete : Fedro', 'Plato, Luis Gil, María. Araujo', '', 1, 'Sarpe', '1985-01-01', 0, '184.P66', '302', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1224, 'Así habló Zarathustra', 'Friedrich Wilhelm Nietzsche, Juan Carlos García Borrón', '', 1, 'Sarpe', '1983-01-01', 0, '193.9.N56', '303', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1225, 'Metafísica', 'Aristòtil, Francisco de P. Samaranch', '', 1, 'Sarpe', '1984-01-01', 0, '109.A72', '304', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1226, 'Fragmentos sobre la historia de la filosofía', 'Arthur Schopenhauer, Vicente Romano García', '', 1, 'Sarpe', '1984-01-01', 0, '109.S29', '305', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1227, 'De los principios de la naturaleza ; El ente y la esencia ; Sobre la eternidad del mundo ; selección de textos de Suma contra Los Gentiles y Suma Teológica', 'Tomás de Aquino, Ángel J. Cappelletti, Manuel Fuentes Benot, José Antonio Míguez', '', 1, 'Sarpe', '1985-01-01', 0, '109.A65', '306', 'E1, B - ESTE, FILA 1, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1228, 'Biblioteca de Cultura Peruana Contemporanea. Tomo IX. Pedagogía', 'Carlos Salazar Romero', '', 1, 'Ediciones del Sol', '1963-01-01', 0, '985.008.S18', '307', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Historia y Geografía'),
(1229, 'Biblioteca de Cultura Peruana Contemporanea. Tomo II. Derecho', 'Domingo Garcia Rada', '', 1, 'Ediciones del Sol', '1963-01-01', 0, '985.008.G18', '308', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Historia y Geografía'),
(1230, 'Biblioteca de Cultura Peruana Contemporanea. Tomo III. Derecho', 'Domingo Garcia Rada', '', 1, 'Ediciones del Sol', '1963-01-01', 0, '985.008.G18', '309', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Historia y Geografía'),
(1231, 'Biblioteca de Cultura Peruana Contemporanea. Tomo V. Historia del Peru', 'Cesar Pacheco Velez', '', 1, 'Ediciones del Sol', '1963-01-01', 0, '985.008.P13', '310', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Historia y Geografía'),
(1232, 'Manual de correspondencia comercial', 'L. E. Frailey', '', 1, 'UTEHA', '1958-01-01', 0, '652.F81', '311', 'E1, B - ESTE, FILA 1, DERECHA', 'Brelona', '', ' ', 1, 'Tecnología (Ciencias Aplicadas)'),
(1233, 'Desarrollo personal social (Familia y civismo)', 'Cueto, Alonso; Cueto, Santiago', '', 1, 'Brasa', '1954-01-01', 0, '320.4.C93', '312', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Ciencias Sociales'),
(1234, 'Breve historia del periódico norteamericano', 'John Tebbel, Enrique Gual', '', 1, 'Montaner y Simón', '1967-01-01', 0, '071.3.T28', '314', 'E1, B - ESTE, FILA 1, DERECHA', 'Barcelona', '', ' ', 1, 'Generalidades'),
(1235, 'El periodismo industrial', 'James McCloskey, Josep María Espinàs', '', 1, 'Zeus', '1960-01-01', 0, '070.486.M12', '316', 'E1, B - ESTE, FILA 1, DERECHA', 'Barcelona', '', ' ', 1, 'Generalidades'),
(1236, 'Cooperatismo y cooperativismo', 'Salvador Marbán Santos', '', 1, 'UTEHA', '1968-01-01', 0, '334.M26', '317', 'E1, B - ESTE, FILA 1, DERECHA', 'Mexico', '', ' ', 1, 'Ciencias Sociales'),
(1237, 'Arte y sentido del periodismo', 'E.D.Coblentz', '', 1, 'Troquel', '1966-01-01', 0, '070.973.C71', '318', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Generalidades'),
(1238, 'La prensa y la opinión pública', 'Nikolai Grigor\'evich Palgunov', '', 1, 'Cartago', '1966-01-01', 0, '344.P19', '320', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1239, 'Agendatel XXI : exégesis de la Ley de telecomunicaciones y Agenda para el nuevo milenio', 'Herley Vidal Llerena García', '', 1, 'Asoc. de Consumidores y Usuarios', '2002-01-01', 0, '343.LL37', '325', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Ciencias Sociales'),
(1240, 'Ley de telecomunicaciones : herramienta para el desarrollo', 'Luis Alberto Maraví Sáez', '', 2, 'Ojbac', '1993-01-01', 0, '343.099.M26', '326;327', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Ciencias Sociales'),
(1241, 'La ciencia : su método y su filosofía', 'Mario Augusto Bunge', '', 1, 'Siglo veinte', '1985-01-01', 0, '330.B92', '328', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1242, 'Prelecciones de Logica', 'Bernardo de la Concha', '', 1, 'Tipografía Católica Casals', '1930-01-01', 0, '160.C72', '330', 'E1, B - ESTE, FILA 1, DERECHA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1243, 'Filosofía y lógica: quinto grado de educación secundaria', 'Juan Germán Prado Q.', '', 1, 'Escuela Nueva', '1995-01-01', 0, '100.P84', '331', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1244, 'Inicio en epistemología (filosofía y teoría de la ciencia)', 'Solís Espinoza, Ciro', '', 1, 'San Marcos', '2007-01-01', 0, '', '332', 'E1, B - ESTE, FILA 1, DERECHA', 'Lima', '', ' ', 1, '#VALUE!'),
(1245, 'Lecciones de lógica y metodología', 'Eugenio Pennati', '', 1, 'D. Bosco', '1956-01-01', 0, '160.P41', '333', 'E1, B - ESTE, FILA 1, DERECHA', 'La Paz', '', ' ', 1, 'Filosofía y Psicología'),
(1246, 'Educacion Sexual', 'E. Nelson', '', 1, 'Alsina', '1946-01-01', 0, '613.907.U74', '334', 'E1, B - ESTE, FILA 1, DERECHA', 'Argentina', '', ' ', 1, 'Tecnología (Ciencias Aplicadas)'),
(1247, 'El Matrimonio', 'Van de Velde', '', 1, 'Claridad', '1939-01-01', 0, '173.V28', '335', 'E1, B - ESTE, FILA 1, DERECHA', 'Argentina', '', ' ', 1, 'Filosofía y Psicología'),
(1248, 'Tragedia Biologia Mujer', 'Juan Lazarte', '', 1, 'Parmeton', '1947-01-01', 0, '305.3.N39', '336', 'E1, B - ESTE, FILA 1, DERECHA', 'Argentina', '', ' ', 1, 'Ciencias Sociales'),
(1249, 'Problemas psicológicos actuales', 'Emilio Mira y López', '', 1, 'El Ateneo', '1960-01-01', 0, '150.2.M63', '337', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1250, 'Historias del Amor', 'M. Grepon', '', 1, 'Parneton', '1949-01-01', 0, '152.41.C88', '338', 'E1, B - ESTE, FILA 1, DERECHA', 'Argentina', '', ' ', 1, 'Filosofía y Psicología'),
(1251, 'Logica, Matematica y Lenguaje Nª1', 'Diaz Mosto', '', 1, 'Tecnicos', '2003-01-01', 0, '510.76.D69', '339', 'E1, B - ESTE, FILA 1, DERECHA', 'Peru', '', ' ', 1, 'Ciencias Puras'),
(1252, 'Logica, Matematica y Lenguaje Nª2', 'Diaz Mosto', '', 1, 'Tecnicos', '2003-01-01', 0, '510.76.D69', '340', 'E1, B - ESTE, FILA 1, DERECHA', 'Peru', '', ' ', 1, 'Ciencias Puras'),
(1253, 'Logica, Matematica y Lenguaje Nª3', 'Diaz Mosto', '', 1, 'Tecnicos', '2003-01-01', 0, '510.76.D69', '341', 'E1, B - ESTE, FILA 1, DERECHA', 'Peru', '', ' ', 1, 'Ciencias Puras'),
(1254, 'Resumen y formulario de aplicaciones de Aritmetica, algebra, geometria, trigonometria, fisica y quimica', 'Diaz Mosto', '', 1, 'Tecnicos', '2003-01-01', 0, '510.76.D69', '342', 'E1, B - ESTE, FILA 1, DERECHA', 'Peru', '', ' ', 1, 'Ciencias Puras'),
(1255, 'Ejercicios y Problremas de Aritmetica, algebra, geometria, trigonometria, fisica y quimica', 'Diaz Mosto', '', 1, 'Tecnicos', '2003-01-01', 0, '510.76.D69', '343', 'E1, B - ESTE, FILA 1, DERECHA', 'Peru', '', ' ', 1, 'Ciencias Puras'),
(1256, 'Hambre por un mundo mejor', 'Butron', '', 2, 'El Sol', '1977-01-01', 0, '370.14.V17', '344;346', 'E1, B - ESTE, FILA 1, DERECHA', 'Peru', '', ' ', 1, 'Ciencias Sociales'),
(1257, 'Freud y la Perversion de las Masas', 'J. Gómez Nerea', '', 1, 'Tor', '1940-01-01', 0, '150.G64', '347', 'E1, B - ESTE, FILA 1, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1258, 'Freud y la higiene sexual', 'J. Gómez Nerea', '', 1, 'Tor', '1940-01-01', 0, '391.65.G64', '350', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1259, 'Freud y el Problema Sexual', 'J. Gómez Nerea', '', 1, 'Tor', '1940-01-01', 0, '155.3.G64', '351', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1260, 'Origenes del Sexo', 'J. Gómez Nerea', '', 1, 'Tor', '1940-01-01', 0, '155.3.G64', '352', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1261, 'Psicologia Social', 'Peter R. Hofstatter', '', 1, 'Uteha', '1960-01-01', 0, '302.H66', '353', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Ciencias Sociales'),
(1262, 'La psicología en la industria y el comercio', 'Walter Moede', '', 1, 'Uteha', '1961-01-01', 0, '158.7.M56', '354', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1263, 'Psicología general', 'Theodor Erismann, Miguel Pereyra', '', 1, 'Uteha', '1966-01-01', 0, '1.50E+75', '355', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1264, 'El psicoanalisis', 'Antonio Miotto, Baltasar, Tr Samper', '', 1, 'Uteha', '1962-01-01', 0, '150.195.M62', '356', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1265, 'Antología del psicoanálisis', 'Elemire Zolla', '', 1, 'Uteha', '1962-01-01', 0, '131.Z85', '357', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1266, 'El pensamiento vivo de Claude Bernard', 'Claude Bernard, Jaume Pi-Sunyer Bayo', '', 1, 'Losada', '1944-01-01', 0, '131.P52', '359', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1267, 'El pensamiento vivo de Cajal', 'Santiago Ramón y Cajal, Felipe Jiménez de Asúa', '', 1, 'Losada', '1941-01-01', 0, '131.T54', '360', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1268, 'Introducción a la psicología', 'Werner Wolff', '', 1, 'Fondo de Cultura Económica', '1953-01-01', 0, '150.W78', '361', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1269, 'Adolescencia mundo desconocido', 'José Rosario Vaccaro', '', 1, 'Ediciones Paulinas', '1964-01-01', 0, '155.532.R84', '363', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Bogota', '', ' ', 1, 'Filosofía y Psicología'),
(1270, 'La Expresion de las Emociones en el Hombre y en los Animales Tomo I', 'Carlos R. Darwin', '', 1, 'Sociedad de Ediciones Mundiales', '1967-01-01', 0, '152.4.D3', '365', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1271, 'La psicología contemporánea', 'J. Vicente Viqueira', '', 1, 'Editora Nacional', '1965-01-01', 0, '150.V73', '366', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1272, 'Introducción a la psicología : y direcciones de la psicología en la actualidad', 'August Messer', '', 1, 'Ed. Losada S.A', '1946-01-01', 0, '150.M44', '369', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1273, 'Introducción a la caracterología', 'Hubert Rohracher', '', 1, 'Ed. Losada S.A', '1945-01-01', 0, '155.2.R76', '370', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1274, 'Introducción al psicoanálisis', 'Sigmund Freud, Luis López Ballesteros y de Torres', '', 1, 'Alianza', '1967-01-01', 0, '150.F83', '371', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1275, 'La personalidad y sus ajustes', 'Richard S. Lazarus', '', 1, 'Uteha', '1965-01-01', 0, '155.2.L32', '372', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1276, 'Tesis Mentales Significado, Uso y Valor', 'Carlos A. Veranelli', '', 1, 'Kapelusz', '1959-01-01', 0, '153.93.V39', '373', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1277, 'Psicología recreativa', 'K. Platonov', '', 1, 'Cartago', '1969-01-01', 0, '155.418.P66', '375', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1278, 'La psicologia de los jóvenes : para que ellas los conozcan', 'Edward Montier, Fernando Moisén', '', 1, 'Studium', '1966-01-01', 0, '155.532.M84', '376', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1279, 'Psicología de la edad juvenil', 'Eduard Spranger, José Gaos', '', 1, 'Editora Nacional', '1965-01-01', 0, '155.5.S77', '377', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1280, 'Ensayos sobre individualidad', 'Félix Morley', '', 1, 'Agora', '1958-01-01', 0, '141.4.M86', '378', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1281, 'La inversion sexual', 'Henry Havelock Ellis', '', 1, 'Partenon', '1947-01-01', 0, '155.3.E42', '380', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1282, 'La seleccion sexual en el hombre', 'Henry Havelock Ellis', '', 1, 'Partenon', '1947-01-01', 0, '575.5.E42', '381', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Ciencias Puras'),
(1283, 'Fisiología del amor moderno', 'Paul Bourget', '', 1, 'Partenon', '1945-01-01', 0, '152.41.B77', '382', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1284, 'El sexo en la civilización Tomo 2', 'Henry Havelock Ellis', '', 1, 'Partenon', '1947-01-01', 0, '155.3.E42', '383', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1285, 'La madurez del amor : serie de ensayos sobre las relaciones de los sexos', 'Edward Carpenter', '', 1, 'Partenon', '1949-01-01', 0, '152.41.C28', '384', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1286, 'Amor y matrimonio', 'Ellen Karolina Sofia Key', '', 1, 'Partenon', '1948-01-01', 0, '152.41.K48', '385', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1287, 'Psicologia Sexual', 'Havelock Ellis', '', 1, 'Partenon', '1949-01-01', 0, '155.3.E42', '386', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1288, 'Tests mentales : Significado, uso y valor', 'Carlos A. Veronell', '', 1, 'Partenon', '1959-01-01', 0, '153.93.V39', '387', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1289, 'Análisis caracterológico de los alumnos de un curso realizado por su maestro : (con cuestionario)', 'Roger Gaillat', '', 1, 'Kapelusz', '1967-01-01', 0, '155.2.G13', '388', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1290, 'Psicología', 'Carlos Cueto Fernandini', '', 1, 'Ministerio de Educación Pública', '1965-01-01', 0, '150.C95', '389', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1291, 'Vigencia de Sigmund Freud', 'Jean Bertrand Pontalis', '', 1, 'Siglo Veinte', '1957-01-01', 0, '150.1952.P77', '390', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1292, 'El sexo en la civilización Tomo 1', 'Henry Havelock Ellis', '', 1, 'Partenon', '1947-01-01', 0, '155.3.E42', '391', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1293, 'Desarrollo psicológico del niño', 'Paul Henry Mussen', '', 1, 'Uteha', '1972-01-01', 0, '155.4.M98', '392', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1294, 'Lecciones de psicología', 'Gregorio Fingermann', '', 1, 'El Ateneo', '1962-01-01', 0, '150.F52', '393', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1295, 'La Expresion de las Emociones en el Hombre y en los Animales Tomo V', 'Carlos R. Darwin', '', 1, 'Sociedad de Ediciones Mundiales', '1967-01-01', 0, '152.4.D25', '394', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1296, 'La personalidad creadora : Técnicas psicológicas y liberación interior', 'Antonio Blay Fontcuberta', '', 1, 'Dharma', '1963-01-01', 0, '155.2.B61', '396', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1297, 'Caracterología de la infancia y de la adolescencia', 'Andre Le Gall, Miguel Siguán', '', 1, 'Luis Miracle', '1962-01-01', 0, '155.2.G15', '397', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1298, 'El punto de partida del filosofar', 'Risieri Frondizi', '', 1, 'Losada', '1957-01-01', 0, '142.F85', '400', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1299, 'Historia de la filosofía inglesa', 'W. R. Sorley', '', 1, 'Losada', '1951-01-01', 0, '190.S68', '401', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1300, 'El puesto del hombre en el cosmos', 'Max Scheler, Francisco Romero', '', 1, 'Losada', '1938-01-01', 0, '129.33.S29', '402', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1301, 'Antropologia filosofica', 'Bernhard Groethuysen', '', 1, 'Losada', '1951-01-01', 0, '128.G82', '403', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1302, 'Gramática especulativa', 'Tomás de Erfurt', '', 1, 'Losada', '1947-01-01', 0, '401.E37', '404', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Lenguas'),
(1303, 'Crítica de la razón pura : estética trascendental y analítica trascendental', 'Immanuel Kant', '', 1, 'Losada', '1953-01-01', 0, '123.2.R21', '405', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1304, 'Escepticismo y fe animal : (introducción a un sistema de filosofía)', 'Autores:Piérola Raúl A, trad (Colaborador), Rosemberg, Marcos A, trad (Colaborador), Santayana, Ge', '', 1, 'Losada', '1952-01-01', 0, '126.7.S21', '406', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1305, 'Tres filósofos del Renacimiento : Bruno, Galileo, Campanella', 'Rodolfo Mondolfo', '', 1, 'Losada', '1947-01-01', 0, '119.6.M84', '407', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1306, 'El pragmatismo en la filosofía contemporánea : ensayo crítico, con un apéndice bilbliográfico', 'Ugo Spirito', '', 1, 'Losada', '1945-01-01', 0, '108.S75', '408', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1307, 'Investigación sobre la moral', 'David Hume', '', 1, 'Losada', '1945-01-01', 0, '122.4.H93', '409', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1308, 'La ciencia y el mundo moderno', 'Alfred North Whitehead', '', 1, 'Losada', '1949-01-01', 0, '108.N82', '410', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1309, 'Introducción general al estudio de las doctrinas hindúes', 'René Guénon', '', 1, 'Losada', '1945-01-01', 0, '181.4.G86', '411', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1310, 'La filosofía como el pensar del mundo de acuerdo con el principio de menor gasto de energía', 'Richard Heinrich Ludwig Avenarius, Najmen Grinfeld', '', 1, 'Losada', '1947-01-01', 0, '124.9.A91', '412', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1311, 'Poética : la imaginación del poeta, las tres épocas de la estética moderna y su problema actual', 'Wilhelm Dilthey', '', 1, 'Losada', '1961-01-01', 0, '801.1.D24', '413', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Literatura'),
(1312, 'Cuatro visiones de la historia universal', 'José Ferrater Mora', '', 1, 'Losada', '1945-01-01', 0, '901.F43', '414', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Historia y Geografía'),
(1313, 'Sobre la percepción métrica', 'Carlos Vaz Ferreira', '', 1, 'Losada', '1956-01-01', 0, '370.81.V38', '415', 'E1, B - ESTE, FILA 2, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1314, 'Novum organum', 'Francis Bacon, Risieri Frondizi (Editor), Clemente Hernando Balmori', '', 1, 'Losada', '1961-01-01', 0, '122.1.B12', '416', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1315, 'La libertad creadora', 'Alejandro Korn', '', 1, 'Losada', '1944-01-01', 0, '129.82.K76', '417', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1316, 'Las teorías de la inducción y de la experimentación', 'André Lalande', '', 1, 'Losada', '1944-01-01', 0, '169.54.L18', '418', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1317, 'Papeles para una filosofía', 'Francisco Romero', '', 1, 'Losada', '1945-01-01', 0, '108.R81', '419', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1318, 'Modos de pensamiento', 'Alfred North Whitehead', '', 1, 'Losada', '1944-01-01', 0, '129.22.N82', '420', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1319, 'Bosquejo de una clasificación sistemática de las doctrinas filosóficas', 'Charles Bernard Renouvier', '', 1, 'Losada', '1948-01-01', 0, '124.81.R41', '421', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1320, 'El pensamiento antiguo: historia de la filosofía greco-romana: desde los orígenes hasta Platón', 'Rodolfo Mondolfo', '', 1, 'Losada', '1959-01-01', 0, '110.9.M84', '422', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1321, 'Del conocimiento de Dios y de sí mismo', 'Jacques Bénigne Bossuet, Ernesto Palacio', '', 1, 'Losada', '1945-01-01', 0, '108.B13', '423', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1322, 'Figuras e ideas de la filosofía del renacimiento', 'Rodolfo Mondolfo', '', 1, 'Losada', '1954-01-01', 0, '119.6.M84', '424', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1323, 'Sobre la organización de las ciencias filosóficas', 'Théodore Simon Jouffroy, Miguel Angel Virasoro', '', 1, 'Losada', '1952-01-01', 0, '100.J76', '426', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1324, 'Estudio de Historia de las Ideas', 'Francisco Romero', '', 1, 'Losada', '1953-01-01', 0, '109.R81', '427', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1325, 'La fe filosófica', 'Karl Jaspers', '', 1, 'Losada', '1953-01-01', 0, '193.J25', '428', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1326, 'Proceso y realidad', 'Alfred North Whitehead', '', 1, 'Losada', '1956-01-01', 0, '116.111.W54', '429', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1327, 'Filosofia de la Paz', 'Jose Juan Bruera', '', 1, 'Losada', '1953-01-01', 0, '172.4.B85', '430', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1328, 'Filosofia Contemporanea Estudios y Notas', 'Francisco Romero', '', 1, 'Losada', '1953-01-01', 0, '129.R81', '431', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1329, 'Sentido y sinsentido', 'Walter Blumenfeld', '', 1, 'Losada', '1949-01-01', 0, '156.3.B65', '432', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1330, 'Diario metafisico', 'Gabriel Marcel', '', 1, 'Losada', '1965-01-01', 0, '110.M26', '433', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1331, 'Nuevos prolegómenos a la metafísica', 'Angel Vassallo', '', 1, 'Losada', '1945-01-01', 0, '140.V11', '435', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1332, 'Correspondencia con Arnauld', 'Gottfried Wilhelm Leibniz, Antoine Arnauld', '', 1, 'Losada', '1946-01-01', 0, '123.1.L42', '436', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1333, 'Introduccion a la filosofia de la historia', 'Raymond Aron', '', 1, 'Losada', '1946-01-01', 0, '901.A17', '437', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Historia y Geografía'),
(1334, 'Los dilemas de la metafísica pura', 'Charles Renouvier, José Ferrater Mora', '', 1, 'Losada', '1944-01-01', 0, '110.R41', '438', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1335, 'El pensamiento antiguo: historia de la filosofía Greco-Romana: desde Aristóteles hasta los neoplatónicos', 'Rodolfo Mondolfo', '', 1, 'Losada', '1942-01-01', 0, '110.9.M84', '439', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1336, 'Análisis del conocimiento científico', 'Simón Marcelo Neuschlosz', '', 1, 'Losada', '1944-01-01', 0, '151.N47', '440', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1337, 'Enéadas : (Enéada I)', 'Plotino, Juan David García Baccá, Juan David García Bacca', '', 1, 'Losada', '1948-01-01', 0, '182.P65', '441', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1338, 'El sistema de Descartes', 'O. Hamelin', '', 1, 'Losada', '1949-01-01', 0, '124.1.H19', '442', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1339, 'Del ente y de la esencia (De ente et essentia)', 'Tomás de Aquino', '', 1, 'Losada', '1940-01-01', 0, '119.42.A65', '443', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1340, 'Investigación sobre el entendimiento humano', 'David Hume', '', 1, 'Losada', '1939-01-01', 0, '153.4.H95', '444', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1341, 'Hacia un saber sobre el alma', 'María. Zambrano', '', 1, 'Losada', '1950-01-01', 0, '108.Z25', '445', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1342, 'Psicologia', 'Carlops Cueto', '', 1, 'Universo', '1965-01-01', 0, '150.C95', '447', 'E1, B - ESTE, FILA 2, DERECHA', 'Peru', '', ' ', 1, 'Filosofía y Psicología'),
(1343, 'Introduccion a la psicologia moderna', 'O. L. Zangwill', '', 1, 'Biblioteca Nueva', '1962-01-01', 0, '150.Z34', '450', 'E1, B - ESTE, FILA 2, DERECHA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1344, 'Nuevo tratado de psicología / vol.1, Nociones preliminares. Introducción. Metodología', 'Georges Dumas', '', 1, 'Kapelusz', '1962-01-01', 0, '150.D97', '453', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1345, 'Nuevo tratado de psicología / vol.2, Los fundamentos de la vida mental', 'Georges Dumas', '', 1, 'Kapelusz', '1962-01-01', 0, '150.D97', '454', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1346, 'Nuevo tratado de psicología / vol.3, Las asociaciones sensitivomotoras', 'Georges Dumas', '', 1, 'Kapelusz', '1960-01-01', 0, '150.D97', '455', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1347, 'Nuevo tratado de psicología / vol.4, Las funciones y las leyes generales', 'Georges Dumas', '', 1, 'Kapelusz', '1962-01-01', 0, '150.D97', '456', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1348, 'Psicología de las muchachas : explicada a las mamás', 'René Boigelot', '', 1, 'Desclée de Brouwer', '1955-01-01', 0, '155.533.B84', '459', 'E1, B - ESTE, FILA 2, DERECHA', 'Bilbao', '', ' ', 1, 'Filosofía y Psicología'),
(1349, 'Psicología social', 'Solomón E. Asch, Elías Mendelievich', '', 1, 'Eudeba', '1964-01-01', 0, '301.A79', '462', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1350, 'Manual de psicología', 'Jean Delay, Pierre Pichot', '', 1, 'Toray-Masson', '1969-01-01', 0, '150.2.D51', '463', 'E1, B - ESTE, FILA 2, DERECHA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1351, 'Contribuciones a la psicología y a la psicopatología', 'Honorio Delgado', '', 1, 'Peri Psyches', '1962-01-01', 0, '616.89.D53', '465', 'E1, B - ESTE, FILA 2, DERECHA', 'Lima', '', ' ', 1, 'Tecnología (Ciencias Aplicadas)'),
(1352, 'Manual práctico de psicología experimental', 'Paul Fraisse', '', 1, 'Kapelusz', '1960-01-01', 0, '153.94.F81', '466', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1353, 'Psicologia de cuarto grado de secundaria', 'Niceforo Espinoza Llanos', '', 1, 'Escuela Nueva', '1950-01-01', 0, '1.50E+80', '467', 'E1, B - ESTE, FILA 2, DERECHA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1354, 'Fundamentos psicológicos de la personalidad : una guía para estudiantes y maestros Tomo I', 'Louis P. Thorpe', '', 1, 'G. Kraft', '1946-01-01', 0, '155.2.T48', '468', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1355, 'Fundamentos psicológicos de la personalidad : una guía para estudiantes y maestros Tomo II', 'Louis P. Thorpe', '', 1, 'G. Kraft', '1946-01-01', 0, '155.2.T48', '469', 'E1, B - ESTE, FILA 2, DERECHA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1356, 'Psicología y educación', 'Carl Gustav Jung', '', 1, 'Paidós', '1949-01-01', 0, '371.420.92.J89', '471', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1357, 'Psicología y cibernética', 'Hernán. Rodríguez', '', 1, 'Siglo Veinte', '1958-01-01', 0, '153.3.R74', '474', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1358, 'El despertar de la sexualidad', 'Rudolf Jahr', '', 1, 'Diana', '1960-01-01', 0, '155.3.J16', '475', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1359, 'El sexo en la civilización', 'Margarita Sanger', '', 1, 'Partenon', '1947-01-01', 0, '155.L32', '476', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1360, 'Los instintos', 'Gaston Viaud', '', 1, 'Kapelusz', '1959-01-01', 0, '153.44.V61', '477', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1361, 'Lecturas para el curso de psicología experimental', 'Rogelio Díaz Guerrero', '', 1, 'Trillas', '1975-01-01', 0, '153.94.D69', '478', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1362, 'Sustancia y función en el problema del yo', 'Risieri Frondizi', '', 1, 'Losada', '1952-01-01', 0, '141.F85', '479', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1363, 'Manual de psicología social', 'Theodore M. Newcomb, Ricardo Enrique José Malfé', '', 1, 'EUDEBA', '1968-01-01', 0, '302.A79', '481', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1364, 'Test abc de verificación de la madurez necesaria para el aprendizaje de la lectura y escritura', 'M. B. Lourenco Filho', '', 1, 'Kapelusz', '1937-01-01', 0, '153.93.F51', '483', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1365, 'El desarrollo psicológico del niño : desde el nacimiento a la adolescencia', 'Charlotte (Malachowski) Buhler, Lorenzo Luzuriaga', '', 1, 'Losada', '1962-01-01', 0, '372.4.B18', '484', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1366, 'Teoría orgánica de las psicosis', 'Pedro Malabia Navarro, Instituto Psiquiátrico Padre Jofre', '', 1, 'Instituto Psiquiátrico \"Padre Jofre\", Valencia', '1954-01-01', 0, '362.260.M19', '486', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Valencia', '', ' ', 1, 'Ciencias Sociales'),
(1367, 'Psicologia para Alumnos de Secundaria', 'César Góngora Perea', '', 1, 'Atlantida', '1948-01-01', 0, '150.G65', '487', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1368, 'Sexo y educación sexual', 'Hernán Romero', '', 1, 'Andrés Bello', '1970-01-01', 0, '613.907.R81', '490', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Santiago', '', ' ', 1, 'Tecnología (Ciencias Aplicadas)'),
(1369, 'Introduccion a la Psicologia 5ª Año', '', 'F.D.T.', 1, 'F.D.T.', '1961-01-01', 0, '151.F41', '492', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1370, 'Lecciones preliminares de Filosofía', 'Manuel García Morente', '', 1, 'Losada', '1938-01-01', 0, '100.7.G23', '493', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1371, 'Trastornos de la personalidad', 'Antonio Miotto', '', 1, 'Uteha', '1961-01-01', 0, '616.858.M62', '495', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Tecnología (Ciencias Aplicadas)'),
(1372, 'Desarrollo psicológico del niño', 'Paul Henry Mussen', '', 1, 'Uteha', '1965-01-01', 0, '155.4.M98', '497', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1373, 'Caracter de la investigacion psicologica', 'Ray Hyman', '', 1, 'Uteha', '1965-01-01', 0, '150.H99', '498', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1374, 'Aprendizaje', 'Sarnoff A. Mednick, Howard R. Pollio, Jorge Gómez de Silva', '', 1, 'Uteha', '1965-01-01', 0, '153.15.M36', '500', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1375, 'Psicología general 2', 'Theodor Erismann, Miguel Pereyra', '', 1, 'Uteha', '1966-01-01', 0, '1.50E+75', '501', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1376, 'Introduccion a la Psicologia', 'I. Diego Perez', '', 1, 'Fernandez Editores', '1963-01-01', 0, '150.P44', '502', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Filosofía y Psicología'),
(1377, 'Psicologia 4ª Año de Secundaria', 'Walter Peñaloza Ramella', '', 3, 'C.M.L.P.', '1964-01-01', 0, '150.P43', '505;506;507', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1378, 'La psicología del niño en edad escolar', 'Albert Millot, M. Debesse, R. Duthil', '', 1, 'Losada', '1945-01-01', 0, '372.4.M58', '509', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Ciencias Sociales'),
(1379, 'Curso elemental de Psicología social', 'José M. Velázquez', '', 1, 'Minerva', '1969-01-01', 0, '150.V34', '510', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Florida,USA', '', ' ', 1, 'Filosofía y Psicología'),
(1380, 'El parto sin dolor tratado práctico', 'Francisco Alonso Aragón', '', 1, 'Quorum', '1986-01-01', 0, '155.6463.A66', '526', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1381, 'Psiquiatría', 'I. F. Sluchevski', '', 1, 'Grijalbo S.A.', '1980-01-01', 0, '615.89.S54', '534', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Mexico', '', ' ', 1, 'Tecnología (Ciencias Aplicadas)'),
(1382, 'La personalidad en la naturaleza, la sociedad y la cultura', 'Clyde Kluckhohn, Henry A. Murray, David M. Schneider, Hortensia E. Acosta', '', 1, 'Grijalbo S.A.', '1969-01-01', 0, '155.2.3.K64', '535', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1383, 'Diccionario de Psicología', 'Alberto L. Merani', '', 1, 'Grijalbo S.A.', '1982-01-01', 0, '150.3.M43', '536', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1384, 'Diccionario de psicoanálisis', 'Jean Laplanche, Daniel Lagache, Jean-Bertrand Pontalis', '', 1, 'Labor', '1987-01-01', 0, '150.3.L12', '537', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1385, 'Obras completas Tomo I', 'Sigmund Freud, Luis López-Ballesteros y de Torres', '', 1, 'Biblioteca Nueva', '1948-01-01', 0, '150.F83', '538', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1386, 'Obras completas Tomo II', 'Sigmund Freud, Luis López-Ballesteros y de Torres', '', 1, 'Biblioteca Nueva', '1948-01-01', 0, '150.F83', '539', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Madrid', '', ' ', 1, 'Filosofía y Psicología'),
(1387, 'Los tests : manual de técnicas de exploración psicológica Segunda Parte', 'Béla Székely', '', 1, 'Kapelusz', '1966-01-01', 0, '153.93.S79', '540', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1388, 'Los tests : manual de técnicas de exploración psicológica Primera Parte', 'Béla Székely', '', 1, 'Kapelusz', '1966-01-01', 0, '153.93.S79', '541', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1389, 'Los tests : manual de técnicas de exploración psicológica Tercera Parte', 'Béla Székely', '', 1, 'Kapelusz', '1966-01-01', 0, '153.93.S79', '542', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1390, 'Tratado de psicologia general …', 'Primavera Acuña de Mones Ruiz, Victor M. Acuña', '', 1, 'Libreria del Colegio', '1949-01-01', 0, '150.A22', '543', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1391, 'Revista de Psicologia', '', 'Asociacion de Psicologos de Arequipa', 1, 'N.A.', '1975-01-01', 0, '150.2.A17', '545', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Arequipa', '', ' ', 1, 'Filosofía y Psicología'),
(1392, 'Psicologia para 4ª Año de Secundaria', 'Hector Perez Bahamonde', '', 2, 'C.M.L.P.', '1970-01-01', 0, '150.P45', '546;547', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Lima', '', ' ', 1, 'Filosofía y Psicología'),
(1393, 'Psicologías del siglo XX', 'Edna Heidbreder', '', 1, 'Paidós', '1964-01-01', 0, '150.H36', '548', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1394, 'Psicología Estudio Metodologico del Mundo Animico', 'Honorio Delgado, Mariano Iberico', '', 1, 'Científico-Médica', '1969-01-01', 0, '150.D53', '550', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Barcelona', '', ' ', 1, 'Filosofía y Psicología'),
(1395, 'Introducción al psicoanálisis para educadores', 'Anna Freud', '', 1, 'Paidós', '1971-01-01', 0, '150.195.F83', '553', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1396, 'La psicología de la forma', 'Paul Guillaume', '', 1, 'Argos', '1951-01-01', 0, '150.G91', '554', 'E1, B - ESTE, FILA 3, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Filosofía y Psicología'),
(1397, 'Puntos de Catesismo', 'R. Villariño', '', 4, 'Graficas', '1949-01-01', 0, '238.V65', '556;557;559;560', 'E1, B - ESTE, FILA 3, DERECHA', 'España', '', ' ', 1, 'Religión'),
(1398, 'La rama dorada; magia y religión; versión española de Elizabeth y Tadeo I. Campuzano', 'James George Frazer', '', 1, 'Fondo de Cultura Económica', '1944-01-01', 0, '205.F81', '561', 'E1, B - ESTE, FILA 3, DERECHA', 'Mexico', '', ' ', 1, 'Religión'),
(1399, 'Seguridad y paz en el conflicto de los siglos', 'Ellen G. White', '', 1, 'Casa Editora Sudamericana', '1955-01-01', 0, '284.W55', '562', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1400, 'Certeza de un futuro Mejor', 'Víctor E. Ampuero Matta', '', 1, 'Casa Editora Sudamericana', '1956-01-01', 0, '240.A55', '564', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1401, 'El Plan de Salvacion de Dios', 'P. Miguel Marina, Juan F de Laiglesia', '', 1, 'N.A.', '1966-01-01', 0, '200.M26', '567', 'E1, B - ESTE, FILA 3, DERECHA', 'Lima', '', ' ', 1, 'Religión'),
(1402, 'Sagrada Biblia. Version directa de las lenguas originales', 'Eloíno Nácar Fuster', '', 1, 'Biblioteca de Autores Cristianos', '1971-01-01', 0, '220.N12', '569', 'E1, B - ESTE, FILA 3, DERECHA', 'Madrid', '', ' ', 1, 'Religión'),
(1403, 'La Biblia : Dios habla hoy', '', 'United Bible Societies', 1, 'Sociedades Bíblicas Unidas', '1993-01-01', 0, '220.N12', '570', 'E1, B - ESTE, FILA 3, DERECHA', 'Corea', '', ' ', 1, 'Religión'),
(1404, 'La locura amorosa en la religión y los pueblos', 'Guido Paci', '', 1, 'Claridad', '1930-01-01', 0, '571.P12', '571', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Ciencias Puras'),
(1405, 'Biografía del Exco. y Rvmo. Mon. Fr. Mariano Holguin, O.F.M., primer arzobispo de Arequiba (Peru), 1860-1945', 'Francisco Cabré', '', 1, 'Editorial \"San Antonio\"', '1959-01-01', 0, '985.92.H71', '572', 'E1, B - ESTE, FILA 3, DERECHA', 'Lima', '', ' ', 1, 'Historia y Geografía'),
(1406, 'El joven de carácter', 'Tihamér Tóth, Antonio Sancho', '', 2, 'Poblet', '1941-01-01', 0, '241.T86', '573;574', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1407, 'El joven del porvenir', 'Tihamér. Tóth', '', 1, 'Poblet', '1944-01-01', 0, '241.T86', '575', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1408, 'El joven observador', 'Tihamér. Tóth', '', 1, 'Poblet', '1940-01-01', 0, '241.T86', '576', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1409, 'El joven creyente', 'Tihamér. Tóth', '', 1, 'Poblet', '1940-01-01', 0, '241.T86', '577', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1410, 'El joven y Cristo', 'Tihamér. Tóth', '', 1, 'Poblet', '1940-01-01', 0, '241.T86', '578', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1411, 'Energía y Pureza : Hacia una juventud fuerte y pura', 'Tihamér. Tóth', '', 1, 'Poblet', '1940-01-01', 0, '241.T86', '579', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1412, 'Nuevo Testamento El Evangelio según San Juan', 'Maximiliano Menese Castañeda', '', 1, 'N.A.', '1954-01-01', 0, '225.M42', '580', 'E1, B - ESTE, FILA 3, DERECHA', 'Lima', '', ' ', 1, 'Religión'),
(1413, 'Una religión para nuestro tiempo', 'Louis Évely', '', 1, 'Ediciones Sígueme', '1964-01-01', 0, '201,E96', '581', 'E1, B - ESTE, FILA 3, DERECHA', 'Salamanca', '', ' ', 1, 'Religión'),
(1414, 'Teodicea : ensayos sobre la bondad de Dios, la libertad del hombre y el origen del mal', 'Víctor E. Ampuero Matta', '', 1, 'Claridad', '1946-01-01', 0, '214.L42', '582', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1415, 'Palabras de vida del gran maestro', 'Elena G. de White', '', 1, 'Casa Editora Sudamericana', '1960-01-01', 0, '284.W54', '583', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1416, 'Cristo Rey o Jesucristo y nuestro siglo', 'Tóth, Tihamér', '', 1, 'Poblet', '1942-01-01', 0, '238.T86', '584', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1417, 'Documentos completos del Vaticano II', 'Concilio Vaticano', '', 3, 'Mensajero', '1972-01-01', 0, '262.5.V66', '585;586;587', 'E1, B - ESTE, FILA 3, DERECHA', 'Bilbao', '', ' ', 1, 'Religión'),
(1418, 'Ciencia y salud : con clave de las escrituras', 'Mary Baker Eddy', '', 1, 'Writings of Mary Baker Eddy', '1971-01-01', 0, '241.B11', '588', 'E1, B - ESTE, FILA 3, DERECHA', 'Boston', '', ' ', 1, 'Religión'),
(1419, 'Las cartas de San Francisco Javier', 'Francisco Javier, José Sola', '', 1, 'Montaner y Simón', '1948-01-01', 0, '202.S66', '589', 'E1, B - ESTE, FILA 3, DERECHA', 'Barcelona', '', ' ', 1, 'Religión'),
(1420, 'El Reino se ha acercado', '', 'International Bible Students Association', 1, 'Watch Tower Bible and Tract Society', '1947-01-01', 0, '201', '590', 'E1, B - ESTE, FILA 3, DERECHA', 'Nueva York', '', ' ', 1, 'Religión');
INSERT INTO `libro` (`id`, `titulo`, `autor_personal`, `autor_corporativo`, `cantidad`, `editorial`, `anio_edicion`, `num_pagina`, `codigo_dewey`, `codigo_libro`, `ubicacion`, `lugar`, `descripcion`, `imagen`, `estado`, `materia`) VALUES
(1421, 'Reflexiones evangélicas, sobre San Juan de Dios', 'Miguel Ruiz Ayúcar', '', 1, 'Mensajero', '1968-01-01', 0, '243.R93', '591', 'E1, B - ESTE, FILA 3, DERECHA', 'Bilbao', '', ' ', 1, 'Religión'),
(1422, 'En el yermo de Dios', 'Alfredo Alexander Jordán', '', 1, 'Tall. Gráf. Bolivianos', '1961-01-01', 0, '240.A39', '592', 'E1, B - ESTE, FILA 3, DERECHA', 'La Paz', '', ' ', 1, 'Religión'),
(1423, 'Historia de Cristo', 'Giovanni Papini', '', 1, 'El Ombú', '1933-01-01', 0, '232.P23', '593', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1424, 'Memorias de Dios', 'Giovanni Papini, Hector F. Miri', '', 1, 'Tor', '1930-01-01', 0, '202.P23', '594', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1425, 'Sé sobrio', 'Tihamér Tóth, Don Antonio Sancho', '', 1, 'Poblet', '1940-01-01', 0, '241.T86', '595', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1426, 'Religion y Doctrinas Contemporaneas', 'Cristobal Polanco Gutierrez', '', 1, 'N.A.', '1952-01-01', 0, '265.P75', '596', 'E1, B - ESTE, FILA 3, DERECHA', 'Arequipa', '', ' ', 1, 'Religión'),
(1427, 'Historia de la Biblia', 'Hendrik Willem Van Loon', '', 1, 'Siglo Veinte', '1946-01-01', 0, '220.W57', '597', 'E1, B - ESTE, FILA 3, DERECHA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1428, 'El Pueblo de Dios: La Iglesia, su historia , su misterio', 'J. L. Idigoras', '', 1, 'Studium', '1965-01-01', 0, '270.I31', '598', 'E1, B - ESTE, FILA 3, DERECHA', 'Lima', '', ' ', 1, 'Religión'),
(1429, 'Visión cristiana del mundo : Respuesta de la Iglesia a diversas cuestiones científicas, filosóficas y sociales de actualidad', 'José Luis Idigoras, E. Bastos', '', 1, 'Editorial Diálogo', '1966-01-01', 0, '200.L31', '600', 'E1, B - ESTE, FILA 3, DERECHA', 'Lima', '', ' ', 1, 'Religión'),
(1430, 'La Nueva Vida Texto para el Segundo Año de Secundaria', 'J. L. Idigoras', '', 1, 'Labor', '1966-01-01', 0, '200.L31', '601', 'E1, B - ESTE, FILA 3, DERECHA', 'Lima', '', ' ', 1, 'Religión'),
(1431, 'La Iglesia Pueblo de Dios 4ª Año de Secundaria', 'Cesar Blondet S.', '', 4, 'Salesiana', '1960-01-01', 0, '268.B69', '492;493;604;605', 'E1, B - ESTE, FILA 3, DERECHA', 'Lima', '', ' ', 1, 'Religión'),
(1432, 'Educacion Moral y Religiosa 1ª Año de Secundaria: El evangelio', 'P. Francisco Cabre', '', 2, 'Juan Antonio Cuzzi M.', '1956-01-01', 0, '207.C12', '602;603', 'E1, B - ESTE, FILA 4, IZQUIERDA', 'Arequipa', '', ' ', 1, 'Religión'),
(1433, 'Curso de Religion La Luz de la Fe para el 5ª Año de Secundaria', 'F. Linares Malaga', '', 4, 'C.M.L.P.', '1960-01-01', 0, '207.L65', '606;607;608;610', 'E1, B - ESTE, FILA 4, IZQUIERDA', 'Lima', '', ' ', 1, 'Religión'),
(1434, 'Educacion Moral y Religiosa 1ª Año de Secundaria: Jesucriso Dios-Hombre', 'Ludovico Maria', '', 1, 'Bruño', '1960-01-01', 0, '200', '611', 'E1, B - ESTE, FILA 4, IZQUIERDA', 'Lima', '', ' ', 1, 'Religión'),
(1435, 'Religion Segundo Año Secundaria', 'Ludovico Maria', '', 1, 'Bruño', '1960-01-01', 0, '200.M26', '612', 'E1, B - ESTE, FILA 4, IZQUIERDA', 'Lima', '', ' ', 1, 'Religión'),
(1436, 'Religion del Cuarto Año de Media', 'N.A.', 'F.D.T.', 1, 'F.T.D.', '1960-01-01', 0, '200', '614', 'E1, B - ESTE, FILA 4, IZQUIERDA', 'Lima', '', ' ', 1, 'Religión'),
(1437, 'Lo mas importante es el amor : edición ilustrada del Nuevo Testamento Viviente', 'Kenneth Nathaniel Taylor', '', 24, 'La Biblioteca Mexicana del Hogar', '1973-01-01', 0, '220.B14', '615;616;617;618;619;620;621;622;623;624;625;626;62', 'E1, B - ESTE, FILA 4, IZQUIERDA', 'Mexico', '', ' ', 1, 'Religión'),
(1438, 'La Manera de vivir en la ciencia cristiana', 'John De Witt', '', 1, 'Christian science publishing society, Boston', '1973-01-01', 0, '207.W55', '640', 'E1, B - ESTE, FILA 4, IZQUIERDA', 'Boston', '', ' ', 1, 'Religión'),
(1439, 'Dios llega al hombre : Nuevo Testamento', 'Sociedades Bíblicas Unidas', '', 20, 'Sociedades Bíblicas Unidas', '1985-01-01', 0, '220.S64', '641; 642; 643; 644; 645; 646; 647; 648; 649; 650; ', 'E1, B - ESTE, FILA 4, IZQUIERDA', 'Buenos Aires', '', ' ', 1, 'Religión'),
(1440, 'Nocturna (Trilogía de la oscuridad 1)', 'Guillermo del Toro, Chuck Hogan', '', 1, 'SUMA INTERNACIONAL', '2001-01-01', 500, '', '7483', 'E1,A-ESTE', 'España', 'Por el creador de la oscarizada El laberinto del fauno, llega Nocturna, la primera entrega de «Trilogía de la Oscuridad». Una estirpe maldita se propaga por el mundo. Y tú tienes algo bajo la piel que los vuelve locos. Un avión procedente de Berlín aterriza en Nueva York. Pero algo no funciona bien desde el momento en que toma tierra. Todas las luces del avión están apagadas, nadie responde a las llamadas de la torre de control, nadie contesta a los teléfonos móviles. Parece como si el avión estuviese muerto... Lo que al principio se considera un virus muy contagioso pronto se revela como algo aterrador. Los «infectados» tienen mucha sed y solo quieren beber... sangre. La epidemia se propaga a una velocidad de vértigo, y en pocos días toda la isla de Manhattan está invadida. Pero esto no ha hecho más que comenzar. Hay un plan siniestro para conquistar rápidamente todo el planeta. Los viejos vampiros han regresado. La lucha entre el bien y el mal vuelve a encarnarse en estas criaturas tan antiguas como actuales. La desigual lucha entre estos seres sobrenaturales y una raleada banda de héroes humanos nos arrastra a una historia llena de acción, alianzas, traiciones y batallas que nos hace reflexionar sobre la condición humana, en la mejor tradición de las películas de su autor, Guillermo del Toro. DESEARÁS QUE SOLO SEA UN CUENTO.', 'logo.png', 1, 'Literatura');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia`
--

CREATE TABLE `materia` (
  `id` int(11) NOT NULL,
  `materia` text NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia_libro`
--

CREATE TABLE `materia_libro` (
  `id` int(11) NOT NULL,
  `id_materia` int(11) NOT NULL,
  `id_libro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `tipo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id`, `nombre`, `tipo`) VALUES
(1, 'Libros', 1),
(2, 'Autor', 2),
(3, 'Editorial', 3),
(4, 'Usuarios', 4),
(5, 'Configuracion', 5),
(6, 'Estudiantes', 6),
(7, 'Materias', 7),
(8, 'Reportes', 8),
(9, 'Prestamos', 9),
(10, 'Carousel', 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `id` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `id_libro` int(11) NOT NULL,
  `fecha_prestamo` date NOT NULL,
  `fecha_devolucion` date NOT NULL,
  `cantidad` int(11) NOT NULL,
  `observacion` text NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamo`
--

INSERT INTO `prestamo` (`id`, `id_estudiante`, `id_libro`, `fecha_prestamo`, `fecha_devolucion`, `cantidad`, `observacion`, `estado`) VALUES
(3, 29, 968, '2025-06-16', '2025-06-19', 1, '', 1),
(4, 20, 1183, '2025-06-17', '2025-06-24', 1, '', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `clave` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `nombre`, `clave`, `estado`) VALUES
(1, 'admin', 'Bibliotecario', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1),
(2, 'mau', 'Administrador general', '519ba91a5a5b4afb9dc66f8805ce8c442b6576316c19c6896af2fa9bda6aff71', 1),
(3, 'mauricio_dav', 'mauricio davila retaamozo', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `autor_libro`
--
ALTER TABLE `autor_libro`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_autor` (`id_autor`),
  ADD KEY `id_libro` (`id_libro`);

--
-- Indices de la tabla `carousel_items`
--
ALTER TABLE `carousel_items`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `chatbot_logs`
--
ALTER TABLE `chatbot_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fecha_hora` (`fecha_hora`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detalle_permisos`
--
ALTER TABLE `detalle_permisos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_permiso` (`id_permiso`);

--
-- Indices de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `faqs`
--
ALTER TABLE `faqs`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `libro`
--
ALTER TABLE `libro`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `materia`
--
ALTER TABLE `materia`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `materia_libro`
--
ALTER TABLE `materia_libro`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_libro` (`id_libro`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `id_libro` (`id_libro`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `autor`
--
ALTER TABLE `autor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `autor_libro`
--
ALTER TABLE `autor_libro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `carousel_items`
--
ALTER TABLE `carousel_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `chatbot_logs`
--
ALTER TABLE `chatbot_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=547;

--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `detalle_permisos`
--
ALTER TABLE `detalle_permisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `faqs`
--
ALTER TABLE `faqs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `libro`
--
ALTER TABLE `libro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1441;

--
-- AUTO_INCREMENT de la tabla `materia`
--
ALTER TABLE `materia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `materia_libro`
--
ALTER TABLE `materia_libro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `autor_libro`
--
ALTER TABLE `autor_libro`
  ADD CONSTRAINT `autor_libro_ibfk_1` FOREIGN KEY (`id_autor`) REFERENCES `autor` (`id`),
  ADD CONSTRAINT `autor_libro_ibfk_2` FOREIGN KEY (`id_libro`) REFERENCES `libro` (`id`);

--
-- Filtros para la tabla `detalle_permisos`
--
ALTER TABLE `detalle_permisos`
  ADD CONSTRAINT `detalle_permisos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `detalle_permisos_ibfk_2` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id`);

--
-- Filtros para la tabla `materia_libro`
--
ALTER TABLE `materia_libro`
  ADD CONSTRAINT `materia_libro_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materia` (`id`),
  ADD CONSTRAINT `materia_libro_ibfk_2` FOREIGN KEY (`id_libro`) REFERENCES `libro` (`id`);

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `prestamo_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id`),
  ADD CONSTRAINT `prestamo_ibfk_2` FOREIGN KEY (`id_libro`) REFERENCES `libro` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
