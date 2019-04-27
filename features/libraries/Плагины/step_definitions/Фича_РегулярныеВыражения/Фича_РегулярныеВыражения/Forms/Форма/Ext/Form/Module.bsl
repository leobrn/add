﻿
#Область Служебные_функции_и_процедуры

&НаКлиенте
// контекст фреймворка Vanessa-ADD
Перем Ванесса;

&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;

&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-ADD.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;

	ВсеТесты = Новый Массив;

	//описание параметров
	//пример вызова Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,ОписаниеШага,ТипШага,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ПеременнаяСоответствуетРегулярномуВыражению(Парам01,Парам02)","ПеременнаяСоответствуетРегулярномуВыражению","Тогда переменная ""ПроверяемаяСтрока"" соответствует регулярному выражению ""\d\d\d""","","Регулярные выражения");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯЗапоминаюСтрокуКакПеременную(Парам01,Парам02)","ЯЗапоминаюСтрокуКакПеременную","Когда Я запоминаю строку ""Привет"" как переменную ""ПроверяемаяСтрока""","","Контекст.Контекст.Сохранить значение");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯЗапоминаюСтрокуКакПеременнуюГлобально(Парам01,Парам02)","ЯЗапоминаюСтрокуКакПеременнуюГлобально","Когда Я запоминаю строку ""Привет"" как переменную ""ПроверяемаяСтрока"" глобально","","Контекст.Контекст сохраняемый.Сохранить значение");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ПеременнаяСоответствуетПростомуШаблону(Парам01,Парам02)","ПеременнаяСоответствуетПростомуШаблону","Тогда переменная ""ПроверяемаяСтрока"" соответствует простому шаблону ""*ри*""","","Регулярные выражения");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ПеременнаяНеСоответствуетРегулярномуВыражению(Парам01,Парам02)","ПеременнаяНеСоответствуетРегулярномуВыражению","Тогда переменная ""ПроверяемаяСтрока"" не соответствует регулярному выражению ""\d{4}""","","Регулярные выражения");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ПеременнаяНеСоответствуетПростомуШаблону(Парам01,Парам02)","ПеременнаяНеСоответствуетПростомуШаблону","Тогда переменная ""ПроверяемаяСтрока"" не соответствует простому шаблону ""*ДругойТекст*""","","Регулярные выражения");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ПеременнаяИмеетЗначениеГлобально(Парам01,Парам02)","ПеременнаяИмеетЗначениеГлобально","Тогда переменная ""ИмяПеременной"" имеет значение ""ЗначениеПеременной"" глобально","Проверяет значение переменной глобального контекста","Контекст.Контекст сохраняемый.Прочитать значение");

	Возврат ВсеТесты;
КонецФункции

&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции

&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции

#КонецОбласти

#Область Работа_со_сценариями

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт

КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт

КонецПроцедуры

#КонецОбласти

///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Когда Я запоминаю строку "Привет" как переменную "ПроверяемаяСтрока"
//@ЯЗапоминаюСтрокуКакПеременную(Парам01,Парам02)
Процедура ЯЗапоминаюСтрокуКакПеременную(ИсходнаяСтрока, ИмяПеременной) Экспорт
	Контекст.Вставить(ИмяПеременной, ИсходнаяСтрока);
КонецПроцедуры

&НаКлиенте
//Когда Я запоминаю строку "Привет" как переменную "ПроверяемаяСтрока" глобально
//@ЯЗапоминаюСтрокуКакПеременнуюГлобально(Парам01,Парам02)
Процедура ЯЗапоминаюСтрокуКакПеременнуюГлобально(ИсходнаяСтрока, ИмяПеременной) Экспорт
	КонтекстСохраняемый.Вставить(ИмяПеременной, ИсходнаяСтрока);
КонецПроцедуры

&НаКлиенте
//Тогда переменная "ЗначениеВариантЗаполненияСостава" имеет значение "Отбор" глобально
//@ПеременнаяИмеетЗначениеГлобально(Парам01,Парам02)
Процедура ПеременнаяИмеетЗначениеГлобально(ИмяПеременной, ОжидаемоеЗначение) Экспорт
	ТекущееЗначение = Неопределено;
	Если НЕ КонтекстСохраняемый.Свойство(ИмяПеременной, ТекущееЗначение) Тогда
		ТекстСообщения = "Переменная <%1> не найдена.";
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", ИмяПеременной);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;

	Если ТекущееЗначение <> ОжидаемоеЗначение Тогда
		ТекстСообщения = "Ожидали, что переменная <%1> будет равна <%2>. Текущее значение <%3>";
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", ИмяПеременной);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%2", ОжидаемоеЗначение);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%3", ТекущееЗначение);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
//Тогда переменная "ПроверяемаяСтрока" соответствует регулярному выражению "/d/d/d"
//@ПеременнаяСоответствуетРегулярномуВыражению(Парам01,Парам02)
Процедура ПеременнаяСоответствуетРегулярномуВыражению(ИмяПеременной, ШаблонРегулярки) Экспорт

	ПроверяемаяСтрока = "";

	Нашли = ПеременнаяСоответствуетРегулярномуВыражениюВнутр(ИмяПеременной, ШаблонРегулярки, ПроверяемаяСтрока);

	Ожидаем = Ванесса.Плагин("УтвержденияBDD");
	Ожидаем.Что(Нашли,
		СтрШаблон_("Ожидали, что проверяемая строка из переменной совпадает с шаблоном регулярного выражения, а это не так
		|Регулярное выражение %1
		|Имя переменной %2
		|Проверяемая строка:
		|%3", ШаблонРегулярки, ИмяПеременной, ПроверяемаяСтрока))
		.ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//Тогда переменная "ПроверяемаяСтрока" не соответствует регулярному выражению "\d{4}"
//@ПеременнаяНеСоответствуетРегулярномуВыражению(Парам01,Парам02)
Процедура ПеременнаяНеСоответствуетРегулярномуВыражению(ИмяПеременной, ШаблонРегулярки) Экспорт

	ПроверяемаяСтрока = "";

	Нашли = ПеременнаяСоответствуетРегулярномуВыражениюВнутр(ИмяПеременной, ШаблонРегулярки, ПроверяемаяСтрока);

	Ожидаем = Ванесса.Плагин("УтвержденияBDD");
	Ожидаем.Что(Нашли,
		СтрШаблон_("Ожидали, что проверяемая строка не совпадает с шаблоном регулярного выражения, а она совпадает, что неверно
		|Регулярное выражение %1
		|Имя переменной %2
		|Проверяемая строка:
		|%3", ШаблонРегулярки, ИмяПеременной, ПроверяемаяСтрока))
		.ЭтоЛожь();
КонецПроцедуры

&НаКлиенте
//Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "*ри*"
//@ПеременнаяСоответствуетПростомуШаблону(Парам01,Парам02)
Процедура ПеременнаяСоответствуетПростомуШаблону(ИмяПеременной, ШаблонРегулярки) Экспорт

	ПроверяемаяСтрока = "";
	Нашли = ПеременнаяСоответствуетПростомуШаблонуВнутр(ИмяПеременной, ШаблонРегулярки, ПроверяемаяСтрока);

	Ожидаем = Ванесса.Плагин("УтвержденияBDD");
	Ожидаем.Что(Нашли,
		СтрШаблон_("Ожидали, что проверяемая строка совпадает с шаблоном регулярного выражения, а это не так
		|Шаблон проверки %1
		|Имя переменной %2
		|Проверяемая строка:
		|%3", ШаблонРегулярки, ИмяПеременной, ПроверяемаяСтрока))
		.ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//Тогда переменная "ПроверяемаяСтрока" не соответствует простому шаблону "*ДругойТекст*"
//@ПеременнаяНеСоответствуетПростомуШаблону(Парам01,Парам02)
Процедура ПеременнаяНеСоответствуетПростомуШаблону(ИмяПеременной, ШаблонРегулярки) Экспорт
	ПроверяемаяСтрока = "";
	Нашли = ПеременнаяСоответствуетПростомуШаблонуВнутр(ИмяПеременной, ШаблонРегулярки, ПроверяемаяСтрока);

	Ожидаем = Ванесса.Плагин("УтвержденияBDD");
	Ожидаем.Что(Нашли,
		СтрШаблон_("Ожидали, что проверяемая строка не совпадает с простым шаблоном, а она совпадает, что неверно
		|Шаблон проверки %1
		|Имя переменной %2
		|Проверяемая строка:
		|%3", ШаблонРегулярки, ИмяПеременной, ПроверяемаяСтрока))
		.ЭтоЛожь();
КонецПроцедуры

&НаКлиенте
Функция ПеременнаяСоответствуетРегулярномуВыражениюВнутр(ИмяПеременной, ШаблонРегулярки, ПроверяемаяСтрока)

	РегулярныеВыражения = Ванесса.Плагин("РегулярныеВыражения");
	РегулярныеВыражения.Подготовить(ШаблонРегулярки);

	ПроверяемаяСтрока = Контекст[ИмяПеременной];

	Нашли = РегулярныеВыражения.Совпадает(ПроверяемаяСтрока);

	Возврат Нашли;
КонецФункции

&НаКлиенте
Функция ПеременнаяСоответствуетПростомуШаблонуВнутр(ИмяПеременной, ШаблонРегулярки, ПроверяемаяСтрока)

	РегулярныеВыражения = Ванесса.Плагин("РегулярныеВыражения");

	ПроверяемаяСтрока = Контекст[ИмяПеременной];

	Нашли = РегулярныеВыражения.СтрокаСоответствуетШаблону(ПроверяемаяСтрока, ШаблонРегулярки);

	Возврат Нашли;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтрШаблон_(Знач СтрокаШаблон, Знач Парам1 = Неопределено, Знач Парам2 = Неопределено, Знач Парам3 = Неопределено, Знач Парам4 = Неопределено, Знач Парам5 = Неопределено)

	МассивПараметров = Новый Массив();
	МассивПараметров.Добавить(Парам1);
	МассивПараметров.Добавить(Парам2);
	МассивПараметров.Добавить(Парам3);
	МассивПараметров.Добавить(Парам4);
	МассивПараметров.Добавить(Парам5);

	Для Сч = 1 По МассивПараметров.Количество() Цикл
		ТекЗначение = МассивПараметров[Сч-1];
		СтрокаШаблон = СтрЗаменить(СтрокаШаблон, "%"+Сч, Строка(ТекЗначение));
	КонецЦикла;

	Возврат СтрокаШаблон;

КонецФункции