﻿&НаКлиенте
Перем ЗапущенныеТестКлиенты;

&НаКлиенте
Перем КонтекстЯдра;

&НаКлиенте
Перем ПортПоУмолчанию;

&НаКлиенте
Перем НастройкиМодальныхОкон;

&НаКлиенте
Перем ЗаголовкиМодальныхОкон;

&НаКлиенте
Перем ПоляМодальныхОкон;

&НаКлиенте
Перем СписокПропускаемыхФорм;

// { Plugin interface
&НаКлиенте
Функция ОписаниеПлагина(КонтекстЯдра, ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	КонтекстЯдраНаСервере = ВнешниеОбработки.Создать("xddTestRunner");
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(КонтекстЯдраНаСервере, ВозможныеТипыПлагинов);
КонецФункции

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	УстановитьНастройкиМодальныхОконПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Функция ПортПоУмолчанию() Экспорт
	Если Не ЗначениеЗаполнено(ПортПоУмолчанию) Тогда
		УстановитьПортПоУмолчанию(52010);
	КонецЕсли;
	Возврат ПортПоУмолчанию;
КонецФункции

&НаКлиенте
Процедура УстановитьПортПоУмолчанию(Знач Порт) Экспорт
	ПортПоУмолчанию = Порт;
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьТестКлиент_ПакетныйРежим(Параметры_xddTestClient, ДопПараметры = Неопределено) Экспорт

	Если ЗначениеЗаполнено(Параметры_xddTestClient) И ТипЗнч(Параметры_xddTestClient[0]) <> Тип("ФиксированныйМассив") 
				Тогда
		НовыйМассивПараметров = Новый Массив;
		НовыйМассивПараметров.Добавить(Параметры_xddTestClient);
		Параметры_xddTestClient = НовыйМассивПараметров;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ДопПараметры) Тогда
		ДопПараметры = "";
	Иначе
		ДопПараметры = ДопПараметры[0];
	КонецЕсли;

	Для Каждого ОчередныеПараметры Из Параметры_xddTestClient Цикл
		Попытка
			ПользовательПарольПорт = РазложитьСтрокуВМассивПодстрок(ОчередныеПараметры[0], ":");
			Если ПользовательПарольПорт.Количество() = 3 Тогда
				ТестКлиент = ПодключитьТестКлиент(
					ПользовательПарольПорт[0],
					ПользовательПарольПорт[1],
					ПользовательПарольПорт[2],
					ДопПараметры);
				ЗапомнитьДанныеТестКлиента(ТестКлиент, ПользовательПарольПорт[0], ПользовательПарольПорт[2],
					ДопПараметры);
			Иначе
				ТестКлиент = ПодключитьТестКлиент("", "", "", ДопПараметры);
				ЗапомнитьДанныеТестКлиента(ТестКлиент, "", "", ДопПараметры);
			КонецЕсли;
		Исключение
			Инфо = ИнформацияОбОшибке();
			ОписаниеОшибки = "Ошибка подключения тест-клиента в пакетном режиме
			|" + ПодробноеПредставлениеОшибки(Инфо);

			ЗафиксироватьОшибкуВЖурналеРегистрации("VanessaADD.ПодключитьТестКлиент", ОписаниеОшибки);
			Сообщить(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Функция ПодключитьТестКлиент(Знач ИмяПользователя = "", Знач Пароль = "", Знач Порт = 0, Знач ДопПараметры = "") Экспорт
	Порт = ПолучитьПорт(Порт);

	Если Не ЗначениеЗаполнено(СписокПропускаемыхФорм) Тогда
		СписокПропускаемыхФорм = Новый СписокЗначений;
	КонецЕсли;

	Результат = Неопределено;

	Попытка
		Выполнить "Результат = Новый ТестируемоеПриложение(, XMLСтрока(Порт));";
	Исключение
		Результат = Неопределено;
	КонецПопытки;

	Если Результат = Неопределено Тогда
		ВызватьИсключение "Не удалось создать объект ТестируемоеПриложение.
		|Возможно, что 1С:Предприятие 8 не было запущено в режиме Менеджера тестирования (ключ командной строки /TESTMANAGER)
		|При запуске Предприятия через Конфигуратор можно включить этот режим в параметрах конфигуратора Сервис -> Параметры -> Запуск 1С:Предприятия -> Дополнительные -> Автоматизированное тестирование -> пункт ""Запускать как менеджер тестирования"".";
	КонецЕсли;

	// Попытка подключиться к уже запущенному приложению.
	Подключен = Ложь;
	Попытка
		Результат.УстановитьСоединение();
		Подключен = Истина;
	Исключение
		Подключен = Ложь;
	КонецПопытки;

	Если Подключен Тогда
		Возврат Результат;
	КонецЕсли;

	СтрокаЗапуска = СтрокаЗапускаТестКлиента(ИмяПользователя, Пароль, Порт, ДопПараметры);

	УправлениеПриложениями = КонтекстЯдра.Плагин("УправлениеПриложениями");
	УправлениеПриложениями.ВыполнитьКомандуОСБезПоказаЧерногоОкна(СтрокаЗапуска, Ложь, Ложь);

	ВремяОкончанияОжидания = ТекущаяДата() + ТаймаутВСекундах();
	ОписаниеОшибкиСоединения = "";
	Пока Не ТекущаяДата() >= ВремяОкончанияОжидания Цикл
		Попытка
			Результат.УстановитьСоединение();
			Подключен = Истина;
			Прервать;
		Исключение
			ОписаниеОшибкиСоединения = ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;

	Если Не Подключен Тогда
		Попытка
			Результат.УстановитьСоединение();
		Исключение
			ОписаниеОшибкиСоединения = ОписаниеОшибки();
			ВызватьИсключение КонтекстЯдра.СтрШаблон_(
			"Не смогли установить соединение с тестовым приложением для пользователя %1!
			|%2",
			ИмяПользователя,
			ОписаниеОшибкиСоединения);
		КонецПопытки;
	КонецЕсли;

	Если Подключен И ОсновноеОкно(Результат) = Неопределено Тогда
		Таймаут = 5;
		ДлительностьОжидания = 0;
		Попытка
			Пока ОсновноеОкно(Результат) = Неопределено И ДлительностьОжидания < ТаймаутВСекундах() Цикл
				Результат.ПолучитьАктивноеОкно().Активизировать();
				ДлительностьОжидания = ДлительностьОжидания + Таймаут;
				Пауза(Результат, Таймаут);
			КонецЦикла;
		Исключение
			ВызватьИсключение КонтекстЯдра.СтрШаблон_(
				НСтр("ru = 'Не смогли установить соединение с тестовым приложением для пользователя %1!'"),
				ИмяПользователя);
		КонецПопытки;
		Если ОсновноеОкно(Результат) = Неопределено Тогда
			Результат.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Отмена").Нажать();
			Результат.РазорватьСоединение();
			ВызватьИсключение НСтр("ru = 'Превышено время ожидания ввода пароля.'");
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ЗавершитьВсеТестКлиенты() Экспорт

	Если Не ЗначениеЗаполнено(ЗапущенныеТестКлиенты) Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ТекЗначение Из ЗапущенныеТестКлиенты Цикл
		Если ЭтоLinux() Тогда
			ЗапуститьПриложение("kill -9 `ps aux | grep -ie TESTCLIENT | grep -ie 1cv8c | awk '{print $2}'`");
		Иначе
			ЗапуститьПриложение(ТекстСкриптаЗавершитьТестКлиент(ТекЗначение.Порт));
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Функция ТестКлиентПоУмолчанию() Экспорт

	Если ЗначениеЗаполнено(ЗапущенныеТестКлиенты) Тогда
		Возврат ЗапущенныеТестКлиенты[0].ТестКлиент;
	КонецЕсли;

	Результат = ПодключитьТестКлиент();
	ЗапомнитьДанныеТестКлиента(Результат, "", "", "");

	Возврат Результат;

КонецФункции

&НаКлиенте
Функция ТестКлиентПоПараметрам(Знач ИмяПользователя = "", Знач Пароль = "", Знач Порт = 0,
		Знач ДопПараметры = "") Экспорт
	Порт = ПолучитьПорт(Порт);

	Результат = НайтиЗапущенныйКлиент(ИмяПользователя, Порт);
	Если Результат <> Неопределено Тогда
		Возврат Результат;
	КонецЕсли;

	Результат = ПодключитьТестКлиент(ИмяПользователя, Пароль, Порт, ДопПараметры);
	ЗапомнитьДанныеТестКлиента(Результат, ИмяПользователя, Порт, ДопПараметры);

	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ИдентифицироватьОкноПредупреждение(Знач ТестКлиент, Знач Пояснение = "", 
										Знач ПропускатьПриОтсутствииПрав = Истина) Экспорт

	ОкноПредупреждение = ОкноПредупреждение(ТестКлиент);

	Если ТипЗнч(ОкноПредупреждение) <> Тип("ТестируемоеОкноКлиентскогоПриложения") Тогда
		Возврат;
	КонецЕсли;

	ТекущаяИнформацияОбОшибке = ТестКлиент.ПолучитьТекущуюИнформациюОбОшибке();
	Если ТипЗнч(ТекущаяИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ТекущаяИнформацияОбОшибке);
	Иначе
		ПодробноеПредставлениеОшибки = "";
	КонецЕсли;

	ТекстИсключения = ТекстИсключения(ОкноПредупреждение);
	ЗакрытьВсеОткрытыеОкна(ТестКлиент);

	Если ПропускатьПриОтсутствииПрав И ТекстИсключения = "Недостаточно прав для просмотра" Тогда
		КонтекстЯдра.ПропуститьТест(ТекстИсключения);
	КонецЕсли;

	ТекстИсключения = СтрШаблон_("Выявлено модальное окно:
		|[%1] %2
		|%3",
		Пояснение,
		ТекстИсключения,
		ПодробноеПредставлениеОшибки);

	КонтекстЯдра.ВызватьОшибкуПроверки(ТекстИсключения);

КонецПроцедуры

&НаКлиенте
Функция ПоявилосьОкноПредупрежденияСТекстом(Знач ТестКлиент, Знач ТекстИсключенияДляПроверки) Экспорт
	
	ОкноПредупреждение = ОкноПредупреждение(ТестКлиент);
	
	Если ТипЗнч(ОкноПредупреждение) <> Тип("ТестируемоеОкноКлиентскогоПриложения") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстИсключения = ТекстИсключения(ОкноПредупреждение);
	
	Возврат Найти(ВРег(ТекстИсключения), ВРег(ТекстИсключенияДляПроверки)) > 0;
	
КонецФункции

&НаКлиенте
Функция ОкноПредупреждение(ТестКлиент)

	ОкноПредупреждение = Неопределено;
	ПодчиненныеОбъекты = ТестКлиент.ПолучитьПодчиненныеОбъекты();

	Для Каждого ПодчиненныйОбъект Из ПодчиненныеОбъекты Цикл
		Если ТипЗнч(ПодчиненныйОбъект) <> Тип("ТестируемоеОкноКлиентскогоПриложения") Тогда
			Продолжить;
		КонецЕсли;
		ОписаниеМодальногоОкна = НайтиПодходящееЗначениеПоКлючуВКоллекции(ЗаголовкиМодальныхОкон, 
			ПодчиненныйОбъект.Заголовок);
		Если ОписаниеМодальногоОкна <> Неопределено Тогда
			ОкноПредупреждение = ПодчиненныйОбъект;
			Прервать;
		КонецЕсли;

		Попытка
			Если ПодчиненныеОбъекты.ПолучитьПодчиненныеОбъекты().Количество() Тогда
				ТестируемаяФорма = ПодчиненныйОбъект.НайтиОбъект(Тип("ТестируемаяФорма"));
				Если ТестируемаяФорма = Неопределено Тогда
					Продолжить;
				КонецЕсли;
			Иначе
				Продолжить;
			КонецЕсли;
		Исключение
			//исключение может быть, если форма открылась и тут же закрылась
		    Продолжить;
		КонецПопытки;

		Если ТестируемаяФорма.ИмяФормы = "" Или ТестируемаяФорма.ИмяФормы = "MessageBox" Тогда
			ОкноПредупреждение = ПодчиненныйОбъект;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат ОкноПредупреждение;

КонецФункции

&НаКлиенте
// Возвращает основное окно текущего тест-клиента
//
// Параметры:
//   ТестКлиент - ТестируемоеПриложение - ТестируемоеПриложение
//
//  Возвращаемое значение:
//   ТестируемоеОкноКлиентскогоПриложения - или Неопределено, если не нашли или ошибка сетевого взаимодействия
//
Функция ОсновноеОкно(ТестКлиент) Экспорт
	Попытка
		КлиентскиеОкнаТестируемогоПриложения = ТестКлиент.ПолучитьПодчиненныеОбъекты();
		Для Каждого ТекОкно Из КлиентскиеОкнаТестируемогоПриложения Цикл
			Если ТекОкно.Основное Тогда
				Возврат ТекОкно;
			КонецЕсли;
		КонецЦикла;
	Исключение
		Возврат Неопределено;
	КонецПопытки;

	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура Пауза(ТестКлиент, КоличествоСекунд) Экспорт

	ТестКлиент.ОжидатьОтображениеОбъекта(Тип("ТестируемаяФорма"), "ЗаведомоОтсутствующийОбъект",, КоличествоСекунд);

КонецПроцедуры

&НаКлиенте
Функция ТекстИсключения(ОкноПредупреждение) Экспорт

	ТекстыЗаголовков = Новый Массив;
	Для Каждого ТекПолеФормы Из ОкноПредупреждение.НайтиОбъекты(Тип("ТестируемоеПолеФормы")) Цикл
		ТекстыЗаголовков.Добавить(ТекПолеФормы.ТекстЗаголовка);
	КонецЦикла;

	Для Каждого ТекДекорацияФормы Из ОкноПредупреждение.НайтиОбъекты(Тип("ТестируемаяДекорацияФормы")) Цикл
		Если ТекДекорацияФормы.Имя = "Message" Тогда
			ТекстыЗаголовков.Добавить(ТекДекорацияФормы.ТекстЗаголовка);
		КонецЕсли;
	КонецЦикла;

	Возврат СтрСоединить_(ТекстыЗаголовков, " ");

КонецФункции

&НаКлиенте
Процедура ЗакрытьВсеОткрытыеОкна(ТестКлиент) Экспорт

	ОкноПредупреждение = ОкноПредупреждение(ТестКлиент);
	ЗакрытьОкноПредупреждения(ОкноПредупреждение);

	ОткрытыеОкна = ТестКлиент.ПолучитьПодчиненныеОбъекты();
	Для Каждого ТекОкно Из ОткрытыеОкна Цикл
		Если ТекОкно.Основное Или ТекОкно.НачальнаяСтраница Тогда
			Продолжить;
		КонецЕсли;
		Если ПропуститьОкно(ТекОкно) Тогда
			Продолжить;
		КонецЕсли;

		Попытка
			ТекОкно.Закрыть();
		Исключение
			// Необходимо принудительно закрыть все окна, специальная обработка исключений не требуется.
			СписокПропускаемыхФорм.Добавить(ТекОкно.Заголовок);
		КонецПопытки;

		ОкноПредупреждение = ОкноПредупреждение(ТестКлиент);
		ЗакрытьОкноПредупреждения(ОкноПредупреждение);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Функция ПропуститьОкно(ТекОкно)

	Если ТекОкно.Основное Или ТекОкно.НачальнаяСтраница Тогда
		Возврат Истина;
	КонецЕсли;

	// В массив добавляем окна, на которых уже вылезали ошибки
	Если СписокПропускаемыхФорм.НайтиПоЗначению(ТекОкно.Заголовок) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ЗакрытьОкноПредупреждения(ОкноПриложения) Экспорт

	Если ТипЗнч(ОкноПриложения) <> Тип("ТестируемоеОкноКлиентскогоПриложения") Тогда
		Возврат;
	КонецЕсли;

	ТипТестируемаяКнопкаФормы = Тип("ТестируемаяКнопкаФормы");

	Кнопки = ОкноПриложения.НайтиОбъекты(ТипТестируемаяКнопкаФормы);
	Если Не ЗначениеЗаполнено(Кнопки) Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ТекПолеФормы Из ОкноПриложения.НайтиОбъекты(Тип("ТестируемоеПолеФормы")) Цикл
		Если НажатьКнопкуМодальногоДиалога(ТекПолеФормы.ТекстЗаголовка, Кнопки, Истина) Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;

	Для Каждого ТекДекорацияФормы Из ОкноПриложения.НайтиОбъекты(Тип("ТестируемаяДекорацияФормы")) Цикл
		Если НажатьКнопкуМодальногоДиалога(ТекДекорацияФормы.ТекстЗаголовка, Кнопки, Истина) Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;

	Если НажатьКнопкуМодальногоДиалога(ОкноПриложения.Заголовок, Кнопки) Тогда
		Возврат;
	КонецЕсли;

	НажатьКнопкуМодальногоДиалогаЕслиНаФормеВсегоОднаКнопка(Кнопки, ОкноПриложения.Заголовок);

КонецПроцедуры

&НаКлиенте
Функция ОткрытыеОкна(ТестКлиент) Экспорт

	ОткрытыеОкна = Новый Соответствие;
	ВсеОкна = ТестКлиент.НайтиОбъекты(Тип("ТестируемоеОкноКлиентскогоПриложения"));
	Для Каждого ТекОкно Из ВсеОкна Цикл
		Если ТекОкно = Неопределено Или ТекОкно.Основное Или ТекОкно.НачальнаяСтраница Тогда
			Продолжить;
		КонецЕсли;
		ОткрытыеОкна.Вставить(ТекОкно.Заголовок, ТекОкно);
	КонецЦикла;

	Возврат ОткрытыеОкна;
КонецФункции

&НаКлиенте
Процедура ПроверитьНаНовыеМодальныеОкна(ТестКлиент, ОткрытыеОкнаДо) Экспорт
	НужноВыброситьИсключение = Ложь;
	Попытка
		ОткрытыеОкна = ТестКлиент.НайтиОбъекты(Тип("ТестируемоеОкноКлиентскогоПриложения"));
		Для Каждого ТекОкно Из ОткрытыеОкна Цикл
			Если ТекОкно = Неопределено Или ТекОкно.Основное Или ТекОкно.НачальнаяСтраница
					Или ОткрытыеОкнаДо.Получить(ТекОкно.Заголовок) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
	
			НужноВыброситьИсключение = Истина;
			Прервать;
		КонецЦикла;
	Исключение
		КонтекстЯдра.ВывестиСообщение("Не удалось проверить модальные окна ",
			СтатусСообщения.ОченьВажное);
		Возврат;
	КонецПопытки;

	Если НужноВыброситьИсключение Тогда
		ТекстИсключения = КонтекстЯдра.СтрШаблон_("
		|Выявлено окно, которое не закрывается!
		|Возможно, это модальное окно.
		|Заголовок окна <%1>", ТекОкно.Заголовок);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиМодальныхОкон(ПарамНастройкиМодальныхОкон) Экспорт
	Если Не ЗначениеЗаполнено(ПарамНастройкиМодальныхОкон) Тогда
		Возврат;
	КонецЕсли;

	Если НастройкиМодальныхОкон <> ПарамНастройкиМодальныхОкон Тогда
		Для Каждого КлючЗначение Из ПарамНастройкиМодальныхОкон Цикл
			НастройкиМодальныхОкон.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;

	ЗаголовкиМодальныхОкон = Новый Соответствие;
	Для Каждого КлючЗначение Из НастройкиМодальныхОкон Цикл
		Описание = КлючЗначение.Значение;
		Если ТипЗнч(Описание) <> Тип("Структура") Тогда
			Продолжить;
		КонецЕсли;
		Заголовки = Неопределено;
		Если Описание.Свойство("Заголовки", Заголовки) Тогда
			Для Каждого Заголовок Из Заголовки Цикл
				ЗаголовкиМодальныхОкон.Вставить(ДляСравнения(Заголовок), Описание);
			КонецЦикла;
		КонецЕсли;

		Поля = Неопределено;
		Если Описание.Свойство("Поля", Поля) Тогда
			Для Каждого ТекстПоля Из Поля Цикл
				ПоляМодальныхОкон.Вставить(ДляСравнения(ТекстПоля), Описание);
			КонецЦикла;
		КонецЕсли;

	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьНастройкиМодальныхОкон() Экспорт
	Возврат НастройкиМодальныхОкон;
КонецФункции

&НаКлиенте
Функция КлючНастройкиМодальныхОкон() Экспорт
	Возврат "МодальныеОкна";
КонецФункции

// } Plugin interface

// { Helpers
&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Функция СтрокаЗапускаТестКлиента(Знач ИмяПользователя, Знач Пароль, Знач Порт, Знач ДопПараметры)

	Если Не ЗначениеЗаполнено(ИмяПользователя) Тогда
		ИмяПользователя = ИмяТекущегоПользователя();
	КонецЕсли;

	СтрокаЗапуска1с = КаталогПрограммы() + "1cv8c";

	Если Не ЭтоLinux() Тогда
		СтрокаЗапуска1с = КонтекстЯдра.СтрШаблон_("%1.exe", СтрокаЗапуска1с);
	КонецЕсли;

	Результат = КонтекстЯдра.СтрШаблон_(
		"""%1"" ENTERPRISE /IBConnectionString""%2""%3%4 /TestClient -TPort%5 /L%6 %7 /DisableStartupMessages",
		СтрокаЗапуска1с,
		СтрЗаменить(СтрокаСоединенияИнформационнойБазы(), """", """"""),
		?(ПустаяСтрока(ИмяПользователя), "", " /N""" + ИмяПользователя + """"),
		?(ПустаяСтрока(Пароль), ""," /P""" + Пароль + """"),
		XMLСтрока(Порт),
		ТекущийЯзык(),
		ДопПараметры);

	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ИмяТекущегоПользователя()

	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();

	Если ТекущийПользователь.АутентификацияОС Тогда
		Возврат "";
	Иначе
		Возврат ТекущийПользователь.Имя;
	КонецЕсли;

КонецФункции

&НаКлиенте
Функция ТаймаутВСекундах()

	Возврат 120;

КонецФункции

&НаКлиенте
Функция ТекстСкриптаЗавершитьТестКлиент(НомерПорта)

	Результат = 
		"wmic process where (CommandLine Like ""%/TESTCLIENT%"" And ExecutablePath Like ""%1cv8c%"") call terminate";

	Если Не ЗначениеЗаполнено(НомерПорта) Тогда
		Возврат Результат;
	КонецЕсли;

	Возврат СтрЗаменить(
	Результат,
	"%/TESTCLIENT%",
	"%/TESTCLIENT -TPort" + НомерПорта + "%");

КонецФункции

&НаКлиенте
Функция ПолноеИмяИсполняемогоФайла()

	Возврат КонтекстЯдра.СтрШаблон_("%1%2%3",
	КаталогПрограммы(),
	"1cv8c",
	РасширениеИсполняемогоФайла());

КонецФункции

&НаКлиенте
Функция РасширениеИсполняемогоФайла()

	Если ЭтоLinux() Тогда
		Возврат "";
	Иначе
		Возврат ".exe";
	КонецЕсли;

КонецФункции

&НаКлиенте
Функция ЭтоLinux()

	СисИнфо = Новый СистемнаяИнформация;
	ВерсияПриложения = СисИнфо.ВерсияПриложения;

	Возврат Найти(Строка(СисИнфо.ТипПлатформы), "Linux") > 0;

КонецФункции

&НаСервере
Процедура ЗафиксироватьОшибкуВЖурналеРегистрации(Знач ИдентификаторГенератораОтчета, Знач ОписаниеОшибки)
	ЗаписьЖурналаРегистрации(ИдентификаторГенератораОтчета, УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьДанныеТестКлиента(ТестКлиент, ИмяПользователя, Порт, ДопПараметры)

	ДанныеТестКлиента = Новый Структура;
	ДанныеТестКлиента.Вставить("ТестКлиент", ТестКлиент);
	ДанныеТестКлиента.Вставить("ИмяПользователя", ИмяПользователя);
	ДанныеТестКлиента.Вставить("Порт", Порт);
	ДанныеТестКлиента.Вставить("ДопПараметры", ДопПараметры);

	Если ЗапущенныеТестКлиенты = Неопределено Тогда
		ЗапущенныеТестКлиенты = Новый Массив;
	КонецЕсли;

	ЗапущенныеТестКлиенты.Добавить(ДанныеТестКлиента);

КонецПроцедуры

&НаКлиенте
Функция НайтиЗапущенныйКлиент(ИмяПользователя, Порт)

	Если Не ЗначениеЗаполнено(ЗапущенныеТестКлиенты) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Для Каждого ТекЗапущенныйКлиент Из ЗапущенныеТестКлиенты Цикл
		Если ТекЗапущенныйКлиент.ИмяПользователя = ИмяПользователя
			И ТекЗапущенныйКлиент.Порт = Порт Тогда
			Возврат ТекЗапущенныйКлиент.ТестКлиент;
		КонецЕсли;
	КонецЦикла;

КонецФункции

&НаКлиенте
Функция ПолучитьПорт(Знач Порт)
	Если Не ЗначениеЗаполнено(Порт) Тогда
		Порт = ПортПоУмолчанию();
	КонецЕсли;
	Возврат Порт;
КонецФункции

&НаКлиенте
Функция НажатьКнопкуМодальногоДиалога(Знач ПроверяемыйТекст, Знач Кнопки, Знач ПроверятьПоля = Ложь)

	Коллекция = ЗаголовкиМодальныхОкон;
	Если ПроверятьПоля Тогда
		Коллекция = ПоляМодальныхОкон;
	КонецЕсли;
	ОписаниеМодальногоОкна = НайтиПодходящееЗначениеПоКлючуВКоллекции(Коллекция, ПроверяемыйТекст);
	Если ОписаниеМодальногоОкна = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	ИндексКнопки = Неопределено;
	Если Не ОписаниеМодальногоОкна.Свойство("Кнопка", ИндексКнопки) Тогда
		Возврат Истина;
	КонецЕсли;
	Если ИндексКнопки < 0 Тогда
		КонтекстЯдра.ВывестиСообщение("Индекс кнопки не должен быть 0 или меньше 0", СтатусСообщения.ОченьВажное);
		Возврат Истина;
	КонецЕсли;
	Если ИндексКнопки >= Кнопки.Количество() Тогда
		КонтекстЯдра.ВывестиСообщение("Индекс кнопки не должен быть больше количества кнопок в форме " + Кнопки.Количество(),
			СтатусСообщения.ОченьВажное);
		Возврат Истина;
	КонецЕсли;

	Попытка
		Кнопки[ИндексКнопки].Нажать();
	Исключение
		КонтекстЯдра.ВывестиСообщение("Не удалось нажать кнопку в форме с заголовком " + ПроверяемыйТекст,
			СтатусСообщения.ОченьВажное);
	КонецПопытки;

	Возврат Истина;

КонецФункции

&НаКлиенте
Функция НажатьКнопкуМодальногоДиалогаЕслиНаФормеВсегоОднаКнопка(Знач Кнопки, Знач ПроверяемыйТекст)
	ПерваяКнопка = НаФормеВсегоОднаКнопка(Кнопки);
	Если ПерваяКнопка = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Попытка
		ПерваяКнопка.Нажать();
	Исключение
		КонтекстЯдра.ВывестиСообщение("Не удалось нажать кнопку в форме с заголовком " + ПроверяемыйТекст,
			СтатусСообщения.ОченьВажное);
	КонецПопытки;

	Возврат Истина;
КонецФункции

&НаКлиенте
Функция НаФормеВсегоОднаКнопка(Знач Кнопки)
	ПерваяКнопка = Кнопки[0];
	Количество = СтрДлина("Command");
	Для Сч = 1 По Кнопки.Количество() Цикл
		Кнопка = Кнопки[Сч];
		Если Лев(Кнопка.ТекстЗаголовка, Количество) = "Command" Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если Сч = 1 Тогда
		Возврат ПерваяКнопка;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Функция ДляСравнения(Знач Строка)
	Возврат НРег(Строка);
КонецФункции

&НаКлиенте
Функция НайтиПодходящееЗначениеПоКлючуВКоллекции(Знач Соответствие, Знач ПроверяемаяСтрока)
	Строка = ДляСравнения(ПроверяемаяСтрока);
	Значение = Соответствие.Получить(Строка);
	Если Значение <> Неопределено Тогда
		Возврат Значение;
	КонецЕсли;

	Для каждого КлючЗначение Из Соответствие Цикл
		СтрокаИлиШаблон = КлючЗначение.Ключ;
		Если КонтекстЯдра.СтрокаСоответствуетШаблону(Строка, СтрокаИлиШаблон) Тогда
			Возврат КлючЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", 
										Знач ПропускатьПустыеСтроки = Неопределено) Экспорт

	Результат = Новый Массив;

	// для обеспечения обратной совместимости
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;

	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Результат.Добавить(Подстрока);
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;

	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Результат.Добавить(Строка);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Замена функции СтрШаблон на конфигурациях с режимом совместимости < 8.3.6
// При внедрении в конфигурацию с режимом совместимости >= 8.3.6 данную функцию необходимо удалить
//
&НаКлиенте
Функция СтрШаблон_(Знач СтрокаШаблон, Знач Парам1 = Неопределено, Знач Парам2 = Неопределено,
	Знач Парам3 = Неопределено, Знач Парам4 = Неопределено, Знач Парам5 = Неопределено) Экспорт

	МассивПараметров = Новый Массив;
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

&НаКлиенте
Функция СтрНачинаетсяС_(Строка, СтрокаПоиска) Экспорт
	Возврат Найти(Строка, СтрокаПоиска) = 1;
КонецФункции

///  Объединяет строки из массива в строку с разделителями.
//
// Параметры:
//  Массив      - Массив - массив строк которые необходимо объединить в одну строку;
//  Разделитель - Строка - любой набор символов, который будет использован в качестве разделителя.
//
// Возвращаемое значение:
//  Строка - строка с разделителями.
//
&НаКлиенте
Функция СтрСоединить_(Массив, Разделитель = ",") Экспорт

	Результат = "";

	Для Индекс = 0 По Массив.ВГраница() Цикл
		Подстрока = Массив[Индекс];

		Если ТипЗнч(Подстрока) <> Тип("Строка") Тогда
			Подстрока = Строка(Подстрока);
		КонецЕсли;

		Если Индекс > 0 Тогда
			Результат = Результат + Разделитель;
		КонецЕсли;

		Результат = Результат + Подстрока;
	КонецЦикла;

	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура УстановитьНастройкиМодальныхОконПоУмолчанию()
	НастройкиМодальныхОкон = Новый Структура;
	ЗаголовкиМодальныхОкон = Новый Соответствие;
	ПоляМодальныхОкон = Новый Соответствие;

    Описание = Новый Структура;
    НастройкиМодальныхОкон.Вставить("Предприятие", Описание);
    Заголовки = Новый Массив;
    Описание.Вставить("Заголовки", Заголовки);
    Заголовки.Добавить("1С:Предприятие");
    Заголовки.Добавить("1C:Enterprise");
    Описание.Вставить("Кнопка", 0);

    Описание = Новый Структура;
    НастройкиМодальныхОкон.Вставить("ПредупреждениеБезопасности", Описание);
    Заголовки = Новый Массив;
    Описание.Вставить("Заголовки", Заголовки);
    Заголовки.Добавить("Предупреждение безопасности");
    Описание.Вставить("Кнопка", 0);

    Описание = Новый Структура;
    НастройкиМодальныхОкон.Вставить("ИзменениеДанных", Описание);
    Заголовки = Новый Массив;
    Описание.Вставить("Поля", Заголовки);
    Заголовки.Добавить("данные были изменены");
    Заголовки.Добавить("сохранить данные");
    Описание.Вставить("Кнопка", 1);

    Описание = Новый Структура;
    НастройкиМодальныхОкон.Вставить("ДанныеБылиИзменены", Описание);
    Заголовки = Новый Массив;
    Описание.Вставить("Заголовки", Заголовки);
    Заголовки.Добавить("Данные были изменены");
    Описание.Вставить("Кнопка", 1);

    Описание = Новый Структура;
    НастройкиМодальныхОкон.Вставить("ВыборТипаДанных", Описание);
    Заголовки = Новый Массив;
    Описание.Вставить("Заголовки", Заголовки);
    Заголовки.Добавить("Выбор типа данных");
    Описание.Вставить("Кнопка", 0);

    Описание = Новый Структура;
    НастройкиМодальныхОкон.Вставить("СписокЗначений", Описание);
    Заголовки = Новый Массив;
    Описание.Вставить("Заголовки", Заголовки);
    Заголовки.Добавить("Список значений");
    Описание.Вставить("Кнопка", 0);

	УстановитьНастройкиМодальныхОкон(НастройкиМодальныхОкон);

КонецПроцедуры

// } Helpers
