-- GROUP BY:
-- 1. Contare quanti iscritti ci sono stati ogni anno:

SELECT
    COUNT(`id`) AS `numero_iscritti`,
    YEAR(`enrolment_date`) AS `per_anno`
FROM
    `students`
GROUP BY
    `per_anno`;

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio:

SELECT
    COUNT(`id`) AS `numero_insegnanti`,
    `office_address` AS `stesso_indirizzo`
FROM
    `teachers`
GROUP BY
    `stesso_indirizzo`;

-- 3. Calcolare la media dei voti di ogni appello d'esame:

SELECT
    AVG(`vote`) AS `media_voto`,
    `exam_id` AS `appello`
FROM
    `exam_student`
GROUP BY
    `appello`
ORDER BY
    `media_voto`
DESC;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento:

SELECT
    COUNT(`id`) AS `corrsi_di_laurea`,
    `department_id` AS `dipartimento`
FROM
    `degrees`
GROUP BY
    `dipartimento`;

-- JOIN:
-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia:

SELECT
    *
FROM
    `degrees`
INNER JOIN `students` ON `degrees`.`id` = `students`.`degree_id`
WHERE
    `degrees`.`name` LIKE '%economia';

-- 2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze:

SELECT
    `degrees`.`level` = 'magistrale' AS `magistrale`,
    `departments`.`name` AS `dipartimento`,
    `degrees`.`name` AS `corso_di_laurea`
FROM
    `departments`
INNER JOIN `degrees` ON `departments`.`id` = `degrees`.`department_id`
WHERE
    `departments`.`name` LIKE '%neuroscienze';

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44):

SELECT
    *
FROM
    `courses`
INNER JOIN `course_teacher` ON `courses`.`id` = `course_teacher`.`course_id`
INNER JOIN `teachers` ON `teachers`.`id` = `course_teacher`.`course_id`
WHERE
    `teachers`.`surname` = 'amato' AND `teachers`.`name` = 'fulvio';

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome:

SELECT
    `students`.`name` AS `nome`,
    `students`.`surname` AS `cognome`,
    `degrees`.`name` AS `corso_di_laurea`,
    `departments`.`name` AS `dipartimento`
FROM
    `departments`
INNER JOIN `degrees` ON `departments`.`id` = `degrees`.`department_id`
INNER JOIN `students` ON `degrees`.`id` = `students`.`degree_id`
ORDER BY
    `students`.`name` AND `students`.`surname`;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti:

SELECT
    `degrees`.`name` AS `corso_di_laurea`,
    `courses`.`name` AS `materia`,
    `teachers`.`name` AS `name`,
    `teachers`.`surname` AS `cognome`
FROM
    `degrees`
INNER JOIN `courses` ON `degrees`.`id` = `courses`.`degree_id`
INNER JOIN `course_teacher` ON `courses`.`id` = `course_teacher`.`course_id`
INNER JOIN `teachers` ON `courses`.`id` = `course_teacher`.`course_id`;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54):

SELECT
    COUNT(DISTINCT `teachers`.`id`) AS `insegnanti_nel_dipartimento_di_matematica`
FROM
    `departments`
INNER JOIN `degrees` ON `departments`.`id` = `degrees`.`department_id`
INNER JOIN `courses` ON `degrees`.`id` = `courses`.`degree_id`
INNER JOIN `course_teacher` ON `courses`.`id` = `course_teacher`.`course_id`
INNER JOIN `teachers` ON `course_teacher`.`teacher_id` = `teachers`.`id`
WHERE
    `departments`.`name` = 'Dipartimento di Matematica';

-- 7. BONUS: Selezionare per ogni studente il numero di tentativi sostenuti per ogni esame, stampando anche il voto massimo. Successivamente, filtrare i tentativi con voto minimo 18:

SELECT
    `students`.`id` AS `studente`,
    `students`.`name`,
    `students`.`surname`,
    `exam_student`.`exam_id`,
    COUNT(`exam_student`.`exam_id`) AS `numero_di_tentativi`,
    MAX(`exam_student`.`vote`) AS `voto_massimo`
FROM
    `students`
JOIN `exam_student` ON `students`.`id` = `exam_student`.`student_id`
JOIN `exams` ON `exam_student`.`exam_id` = `exams`.`id`
GROUP BY 
    `students`.`id`, 
    `exam_student`.`exam_id`
HAVING 
    MAX(`exam_student`.`vote`) >= 18
ORDER BY
    `exam_student`.`vote`;
  

-- FINE
