﻿
&НаКлиенте
Перем КонтекстЯдра;

&НаКлиенте
Перем Утверждения;

&НаКлиенте
Перем ПлагинТестКлиенты;

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ПлагинТестКлиенты = КонтекстЯдра.Плагин("ТестКлиенты");
	
	ПутьНастройки = "CommandInterface";
	НачальнаяНастройка(КонтекстЯдра, ПутьНастройки);
КонецПроцедуры

&НаКлиенте
Процедура НачальнаяНастройка(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;	
	КонецЕсли;

	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	
	НастройкиМодальныхОкон = ПлагинНастроек.ПолучитьНастройку(ПлагинТестКлиенты.КлючНастройкиМодальныхОкон());
	
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Если Не ЗначениеЗаполнено(Объект.Настройки) Тогда
		Объект.Настройки = Новый Структура;
	КонецЕсли;

	НаборНастроекПоУмолчанию = СоздатьНаборНастроекПоУмолчанию();

	ЗаменитьНесуществующиеНастройкиЗначениямиПоУмолчанию(Объект.Настройки, НаборНастроекПоУмолчанию);

	Если ЕстьНастройка("СтрогийПорядокВыполнения", Объект.Настройки) Тогда
		Объект.СтрогийПорядокВыполнения = Объект.Настройки.СтрогийПорядокВыполнения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиМодальныхОкон) Тогда
		Объект.Настройки.Вставить(ПлагинТестКлиенты.КлючНастройкиМодальныхОкон(), НастройкиМодальныхОкон);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ЕстьНастройка(Знач ПутьНастроек, СтруктураНастроек = Неопределено) Экспорт

	Если СтруктураНастроек = Неопределено Тогда
		СтруктураНастроек = Объект.Настройки;
	КонецЕсли;

	Возврат КонтекстЯдра.Плагин("Настройки").ЕстьНастройка(ПутьНастроек, СтруктураНастроек);

КонецФункции

&НаСервере
Функция СоздатьНаборНастроекПоУмолчанию() Экспорт

	Рез = Новый Структура;

	Рез.Вставить("СтрогийПорядокВыполнения", Истина);

	Возврат Новый ФиксированнаяСтруктура(Рез);

КонецФункции

&НаКлиенте
Процедура ЗаменитьНесуществующиеНастройкиЗначениямиПоУмолчанию(Знач Настройки, Знач НаборНастроекПоУмолчанию)

	Для каждого КлючЗначение Из НаборНастроекПоУмолчанию Цикл
		Если Не ЕстьНастройка(КлючЗначение.Ключ) Тогда
			Настройки.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Объект.СтрогийПорядокВыполнения Тогда
		НаборТестов.СтрогийПорядокВыполнения();
		НаборТестов.ПродолжитьВыполнениеПослеПаденияТеста();
	КонецЕсли;
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	
	ПлагинТестКлиенты = КонтекстЯдра.Плагин("ТестКлиенты");
	
	ТестКлиент = Неопределено;
	
	Попытка
		ТестКлиент = ПлагинТестКлиенты.ТестКлиентПоУмолчанию();
	Исключение
		ИнфоОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщить(ИнфоОшибки);
		Возврат;
	КонецПопытки;
	
	Если ТестКлиент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОсновноеОкно = ПлагинТестКлиенты.ОсновноеОкно(ТестКлиент);
	
	ИсключаемыеОперации = Новый Массив;
	ДобавитьИсключения(ИсключаемыеОперации, "ОбщиеКоманды", "ОбщаяКоманда.");
	ДобавитьИсключения(ИсключаемыеОперации, "ОбщиеФормы", "ОбщаяФорма.");
	ДобавитьИсключения(ИсключаемыеОперации, "Справочники", "Справочник.");
	ДобавитьИсключения(ИсключаемыеОперации, "Документы", "Документ.");
	ДобавитьИсключения(ИсключаемыеОперации, "Отчеты", "Отчет.");
	ДобавитьИсключения(ИсключаемыеОперации, "Обработки", "Обработка.");
	ДобавитьИсключения(ИсключаемыеОперации, "БизнесПроцессы", "БизнесПроцесс.");
	ДобавитьИсключения(ИсключаемыеОперации, "ВнешниеИсточникиДанных", "ВнешнийИсточникДанных.");
	
	ОписаниеДобавляемыхТестов = ОписаниеДобавляемыхТестов(ТестКлиент, ОсновноеОкно);
	Для Каждого ГруппаТестов Из ОписаниеДобавляемыхТестов Цикл
		
		СписокДляСортировки = Новый СписокЗначений;
		Для Каждого КлючЗначение Из ГруппаТестов.Тесты Цикл
			Если Не ИсключитьИзПроверки(КлючЗначение.Ключ, ИсключаемыеОперации) Тогда
				СписокДляСортировки.Добавить(КлючЗначение, КлючЗначение.Значение.ПредставлениеТеста);
			КонецЕсли;
		КонецЦикла;
		СписокДляСортировки.СортироватьПоПредставлению();
		
		Если СписокДляСортировки.Количество() Тогда
			НаборТестов.НачатьГруппу(КонтекстЯдра.СтрШаблон_(НСтр("ru = 'Раздел: %1'"),ГруппаТестов.ИмяГруппы));
		КонецЕсли;
		
		Для Каждого ЭлементСпискаЗначений  Из СписокДляСортировки Цикл
			
			КлючЗначение = ЭлементСпискаЗначений.Значение;
			Описание = КлючЗначение.Значение;
			ОписаниеНавигационнаяСсылка = Описание.НавигационнаяСсылка;
			
			НаборТестов.Добавить(
				Описание.ИмяТеста,
				НаборТестов.ПараметрыТеста(ОписаниеНавигационнаяСсылка),
				КонтекстЯдра.СтрШаблон_(НСтр("ru = '%1: проверка элемента командного интерфейса'"), Описание.ПредставлениеТеста));
			
		КонецЦикла;
			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИсключения(Знач ИсключаемыеОперации, ИмяНастройки, ПрефиксШаблона)
	
	Если ВидМетаданныхИсключенИзТестирования(ИмяНастройки) Тогда 
		
		ИсключаемыеОперации.Добавить(ПрефиксШаблона);
		
	ИначеЕсли ЕстьНастройка(ИмяНастройки) Тогда
		
		Для Каждого ПараметрНастройки Из Объект.Настройки[ИмяНастройки] Цикл
			ИсключаемыеОперации.Добавить(ПрефиксШаблона + ПараметрНастройки);
		КонецЦикла;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ИсключитьИзПроверки(ОписаниеНавигационнаяСсылка, ИсключаемыеОперации)

	Для Каждого ШаблонИсключения Из ИсключаемыеОперации Цикл
		Если Найти(ОписаниеНавигационнаяСсылка, ШаблонИсключения) <> 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ПередЗапускомТеста() Экспорт
	
	ПлагинТестКлиенты = КонтекстЯдра.Плагин("ТестКлиенты");
	Если ЕстьНастройка(ПлагинТестКлиенты.КлючНастройкиМодальныхОкон(), Объект.Настройки) Тогда
		ПлагинТестКлиенты.УстановитьНастройкиМодальныхОкон(Объект.Настройки[ПлагинТестКлиенты.КлючНастройкиМодальныхОкон()]);
	КонецЕсли;
	
	ТестКлиент = ПлагинТестКлиенты.ТестКлиентПоУмолчанию();
	ПлагинТестКлиенты.ЗакрытьВсеОткрытыеОкна(ТестКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаТеста() Экспорт
	
	//ТестКлиент = КонтекстЯдра.Плагин("ТестКлиенты").ТестКлиентПоУмолчанию();
	//КонтекстЯдра.Плагин("ТестКлиенты").ЗакрытьВсеОткрытыеОкна(ТестКлиент);
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеДобавляемыхТестов(ТестКлиент, ОсновноеОкно)
	
	РезКоллекцияОписаний = Новый Массив;
	ИсключаемыеРазделы = Новый Массив;
	ДобавитьИсключения(ИсключаемыеРазделы, "Разделы", "");
	
	Попытка
		КомандныйИнтерфейс = ОсновноеОкно.ПолучитьКомандныйИнтерфейс();
	Исключение
		ВызватьИсключение "Не удалось получить командный интерфейс.
		|Возможно, сеанс тест-клиента заблокирован модальным окном";
	КонецПопытки;
	ПанельРазделов = КомандныйИнтерфейс.НайтиОбъект(Тип("ТестируемаяГруппаКомандногоИнтерфейса"), НСтр("ru = 'Панель разделов'; en = 'Section panel'"));
	Если ПанельРазделов = Неопределено Тогда
		ПанельРазделов = КомандныйИнтерфейс.НайтиОбъект(Тип("ТестируемаяГруппаКомандногоИнтерфейса"), "Section panel");
	КонецЕсли;
	
	Если ТипЗнч(ПанельРазделов) = Тип("ТестируемаяГруппаКомандногоИнтерфейса") Тогда
		КнопкиРазделов = ПанельРазделов.НайтиОбъекты(Тип("ТестируемаяКнопкаКомандногоИнтерфейса"));
		Для Каждого ТекКнопкаРаздел Из КнопкиРазделов Цикл
			Если ИсключитьИзПроверки(ТекКнопкаРаздел.ТекстЗаголовка, ИсключаемыеРазделы) Тогда
				Продолжить;
			КонецЕсли;
			СтруктураГруппы = Новый Структура;
			СтруктураГруппы.Вставить("ИмяГруппы", ТекКнопкаРаздел.ТекстЗаголовка);
			СтруктураГруппы.Вставить("Тесты", Новый Соответствие);
			РезКоллекцияОписаний.Добавить(СтруктураГруппы);
			ТекКнопкаРаздел.Нажать();
			ДобавитьОписаниеТеста(СтруктураГруппы.Тесты, КомандныйИнтерфейс);
			ТекКнопкаРаздел.Нажать();
		КонецЦикла;
		
		Если КнопкиРазделов.Количество() > 1 Тогда
			КнопкиРазделов[0].Нажать();
			КнопкиРазделов[0].Нажать();
		КонецЕсли;
	КонецЕсли;
	
	Возврат РезКоллекцияОписаний;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьОписаниеТеста(КоллекцияОписанийТестов, КомандныйИнтерфейс)
	
	Разделы = Новый Массив;
	Разделы.Добавить(КомандныйИнтерфейс);
	Для Каждого Раздел Из КомандныйИнтерфейс.НайтиОбъекты(Тип("ТестируемаяГруппаКомандногоИнтерфейса")) Цикл
		Если ЭтоСлужебныйРаздел(Раздел) Тогда 
			Продолжить;
		КонецЕсли;
		Разделы.Добавить(Раздел);	
	КонецЦикла;
	
	Для Каждого ТекРаздел Из Разделы Цикл
		
		Для Каждого ТекКнопка Из ТекРаздел.НайтиОбъекты(Тип("ТестируемаяКнопкаКомандногоИнтерфейса")) Цикл
			
			Если Найти(ТекКнопка.НавигационнаяСсылка, "e1cib/command/Подсистема.") > 0
				Или Не ЗначениеЗаполнено(ТекКнопка.НавигационнаяСсылка)
				Или ЭтоСлужебныйРазделВерсия82(ТекКнопка) Тогда 
				Продолжить;
			КонецЕсли;
			
			ПредставлениеТеста = КонтекстЯдра.СтрШаблон_("%1->%2", ТекРаздел.ТекстЗаголовка, ТекКнопка.ТекстЗаголовка);
						
			ДобавляемоеОписание = Новый Структура;
			ДобавляемоеОписание.Вставить("ПредставлениеТеста", ПредставлениеТеста);
			ДобавляемоеОписание.Вставить("НавигационнаяСсылка", ТекКнопка.НавигационнаяСсылка);
			ДобавляемоеОписание.Вставить("ИмяТеста", ИмяТеста(ТекКнопка.НавигационнаяСсылка));
			КоллекцияОписанийТестов.Вставить(ТекКнопка.НавигационнаяСсылка, ДобавляемоеОписание);
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Функция ВидМетаданныхИсключенИзТестирования(ВидМетаданных)
	Если ЕстьНастройка(ВидМетаданных) Тогда
		Возврат (ТипЗнч(Объект.Настройки[ВидМетаданных]) = Тип("Булево") И НЕ Объект.Настройки[ВидМетаданных]);
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Функция ИмяТеста(ПараметрНавигационнаяСсылка)
	
	ПропускаемыеНавигационныеСсылки = Новый Массив;
	ПропускаемыеНавигационныеСсылки.Добавить("e1cib/command/ОбщаяКоманда.СтраницаМобильноеПриложениеНаAppStore");
	ПропускаемыеНавигационныеСсылки.Добавить("e1cib/command/ОбщаяКоманда.СтраницаМобильноеПриложениеНаGooglePlay");
	ПропускаемыеНавигационныеСсылки.Добавить("e1cib/command/ОбщаяКоманда.СтраницаПродуктаНаСайте1С");
	ПропускаемыеНавигационныеСсылки.Добавить("e1cib/command/ОбщаяКоманда.СтраницаЧтоНовогоВВерсииВидео");
	ПропускаемыеНавигационныеСсылки.Добавить("e1cib/command/Обработка.Ценообразование.Команда.Ценообразование");
	ПропускаемыеНавигационныеСсылки.Добавить("e1cib/command/ОбщаяКоманда.Налоги_РегламентированнаяОтчетность");
	
	Если ПропускаемыеНавигационныеСсылки.Найти(ПараметрНавигационнаяСсылка) = Неопределено Тогда
		Возврат "ТестДолжен_ПерейтиПоКнопкеКомандногоИнтерфейса";
	Иначе
		Возврат "ТестДолжен_ПропуститьВыполнение";
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ЭтоСлужебныйРаздел(ГруппаКомандногоИнтерфейса)
	
	ЗаголовкиСлужебныхРазделов = Новый Соответствие;
	
	// Такси
	ЗаголовкиСлужебныхРазделов.Вставить(НРег(НСтр("ru = 'Панель разделов'"))                , Истина);
	ЗаголовкиСлужебныхРазделов.Вставить(НРег(НСтр("ru = 'Панель инструментов'"))            , Истина);
	ЗаголовкиСлужебныхРазделов.Вставить(НРег(НСтр("ru = 'Панель открытых'"))                , Истина);
	ЗаголовкиСлужебныхРазделов.Вставить(НРег(НСтр("ru = 'Меню функций'"))                   , Истина);
	
	Возврат ЗаголовкиСлужебныхРазделов.Получить(НРег(ГруппаКомандногоИнтерфейса.ТекстЗаголовка)) = Истина;
	
КонецФункции

&НаКлиенте
Функция ЭтоСлужебныйРазделВерсия82(ГруппаКомандногоИнтерфейса)
	
	ЗаголовкиСлужебныхРазделов = Новый Соответствие;
	
	// Версия 8.2
	ЗаголовкиСлужебныхРазделов.Вставить(НРег(НСтр("ru = 'Отчеты'"))         , Истина);
	ЗаголовкиСлужебныхРазделов.Вставить(НРег(НСтр("ru = 'Сервис'"))         , Истина);
	ЗаголовкиСлужебныхРазделов.Вставить(НРег(НСтр("ru = 'Панель действий'")), Истина);
	
	Возврат ЗаголовкиСлужебныхРазделов.Получить(НРег(ГруппаКомандногоИнтерфейса.ТекстЗаголовка)) = Истина;
	
КонецФункции

&НаКлиенте
Процедура ТестДолжен_ПропуститьВыполнение(ПараметрНавигационнаяСсылка) Экспорт
	
	КонтекстЯдра.ПропуститьТест();
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПерейтиПоКнопкеКомандногоИнтерфейса(ПараметрНавигационнаяСсылка) Экспорт
	
	ТестКлиент = КонтекстЯдра.Плагин("ТестКлиенты").ТестКлиентПоУмолчанию();
	ОсновноеОкно = КонтекстЯдра.Плагин("ТестКлиенты").ОсновноеОкно(ТестКлиент);
	
	ОткрытыеОкнаДо = ПлагинТестКлиенты.ОткрытыеОкна(ТестКлиент);
	
	Попытка
		ОсновноеОкно.ВыполнитьКоманду(ПараметрНавигационнаяСсылка);
	Исключение
		ВызватьИсключение КонтекстЯдра.СтрШаблон_("Не удалось выполнить команду %1 на тест-клиенте.
		|Возможно, сеанс тест-клиента заблокирован модальным окном", ПараметрНавигационнаяСсылка);
	КонецПопытки;
	
	КонтекстЯдра.Плагин("ТестКлиенты").ИдентифицироватьОкноПредупреждение(ТестКлиент, ПереходПоКнопкеКомандногоИнтерфейса(), Ложь);
	
	ОписанияШаговСценария = Новый Массив;
	ОписанияШаговСценария.Добавить(КликПоПервойСтрокеТаблицыФормы());
	ОписанияШаговСценария.Добавить(КликПоПоследнейСтрокеТаблицыФормы());
	
	Для Каждого ШагСценария Из ОписанияШаговСценария Цикл
		ОкноСТаблицейФормы = ТестКлиент.ПолучитьАктивноеОкно();
		Если ОкноСТаблицейФормы.НачальнаяСтраница Или ОкноСТаблицейФормы.Основное Тогда
			Продолжить;
		КонецЕсли;
		Обработали = ВыполнитьШагПроверкиТаблицыФормы(ОкноСТаблицейФормы, ШагСценария, ТестКлиент);
		Если Обработали Тогда
			КонтекстЯдра.Плагин("ТестКлиенты").ИдентифицироватьОкноПредупреждение(ТестКлиент, ШагСценария, Ложь);
		КонецЕсли;
	КонецЦикла;
	
	КонтекстЯдра.Плагин("ТестКлиенты").ЗакрытьВсеОткрытыеОкна(ТестКлиент);
	
	ПлагинТестКлиенты.ПроверитьНаНовыеМодальныеОкна(ТестКлиент, ОткрытыеОкнаДо);
	
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьШагПроверкиТаблицыФормы(ОкноСТаблицейФормы, ШагСценария, ТестКлиент)
	
	ТаблицаФормы = ОкноСТаблицейФормы.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"));
	Если ТаблицаФормы = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Попытка
		Если Не ТаблицаФормы.ТекущаяДоступность() Или Не ТаблицаФормы.ТекущаяВидимость() Тогда
			Возврат Ложь;
		КонецЕсли;
	Исключение
	    //ОписаниеОшибки()
	КонецПопытки;
	
	ПерейтиКЗаданнойСтрокеТаблицыФормы(ШагСценария, ТаблицаФормы, ТестКлиент);
	
	Если Не ЗначениеЗаполнено(ТаблицаФормы.ПолучитьВыделенныеСтроки()) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТаблицаФормы.Выбрать();
	
	КонтекстЯдра.Плагин("ТестКлиенты").ИдентифицироватьОкноПредупреждение(ТестКлиент, ШагСценария, Ложь);
	
	ТекущееОкно = ТестКлиент.ПолучитьАктивноеОкно();
	Если ПриКликеВТаблицеФормыНовоеОкноНеОткрылось(ТекущееОкно, ОкноСТаблицейФормы) Тогда
		Если ТаблицаФормы.ТекущийРежимРедактирование() Тогда
			ТаблицаФормы.ЗакончитьРедактированиеСтроки();
		КонецЕсли;
		Возврат Истина;
	КонецЕсли;
	
	ПроверитьМодифицированность(ШагСценария, ТекущееОкно, ТестКлиент, "При открытии");
	
	НажатьКнопкуЗаписать(ШагСценария, ТекущееОкно, ТестКлиент);
	
	Если ТекущееОкно = ТестКлиент.ПолучитьАктивноеОкно() Тогда
		ПроверитьМодифицированность(ШагСценария, ТекущееОкно, ТестКлиент, "После записи");
	КонецЕсли;
	
	Если ШагСценария = КликПоПервойСтрокеТаблицыФормы() Тогда
		ПроверитьКомандныйИнтерфейсОкна(ТекущееОкно, ТестКлиент);
	КонецЕсли;
	
	ТекущееОкно.Закрыть();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиКЗаданнойСтрокеТаблицыФормы(ШагСценария, ТаблицаФормы, ТестКлиент)
	
	Если ШагСценария = КликПоПервойСтрокеТаблицыФормы() Тогда
		
		ТаблицаФормы.ПерейтиКПервойСтроке();
		
	ИначеЕсли ШагСценария = КликПоПоследнейСтрокеТаблицыФормы() Тогда
		
		ТаблицаФормы.ПерейтиКПоследнейСтроке();
		
	Иначе
		
		ВызватьИсключение КонтекстЯдра.СтрШаблон_("Поведение для шага ""%1"" не определено", ШагСценария);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПриКликеВТаблицеФормыНовоеОкноНеОткрылось(ТекущееОкно, ОкноСТаблицейФормы)
	
	Возврат ТекущееОкно = ОкноСТаблицейФормы;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьМодифицированность(ШагСценария, ТекущееОкно, ТестКлиент, МоментПроверки)
	
	ТестируемаяФорма = ТекущееОкно.НайтиОбъект(Тип("ТестируемаяФорма"));
	ТекущаяМодифицированность = ТестируемаяФорма.ТекущаяМодифицированность();
	Если ТекущаяМодифицированность Тогда
		ТекстИсключения = КонтекстЯдра.СтрШаблон_("%1 - %2 - %3 - %4:
		|Ожидали, что форма не модифицирована сразу же после ее открытия или сразу же после записи, а это не так.",
		ШагСценария, МоментПроверки, ТестируемаяФорма.ИмяФормы, ТестируемаяФорма.ТекстЗаголовка);
		КонтекстЯдра.ВызватьОшибкуПроверки(ТекстИсключения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НажатьКнопкуЗаписать(ШагСценария, ТекущееОкно, ТестКлиент)
	
	КнопкаЗаписать = ТекущееОкно.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Записать");
	Если КнопкаЗаписать = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не КнопкаЗаписать.ТекущаяВидимость() Или Не КнопкаЗаписать.ТекущаяДоступность() Тогда
		Возврат;
	КонецЕсли;
	
	// Платформа не позволяет заранее определить доступность кнопки.
	// Поэтому нажимаем в попытке, а затем ловим исключение, если нажать кнопку не удалось.
	Попытка
		КнопкаЗаписать.Нажать();
	Исключение
		ТекстИсключения = ОписаниеОшибки();
		Если Найти(ТекстИсключения, "Неподходящий тип элемента управления для вызванного действия") = 0 Тогда
			КонтекстЯдра.ВызватьОшибкуПроверки(ТекстИсключения);
		КонецЕсли;
	КонецПопытки;
	
	КонтекстЯдра.Плагин("ТестКлиенты").ИдентифицироватьОкноПредупреждение(
		ТестКлиент,
		КонтекстЯдра.СтрШаблон_("%1: Кнопка ""Записать""", ШагСценария),
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКомандныйИнтерфейсОкна(ТекущееОкно, ТестКлиент)
	
	КомандныйИнтерфейс = ТекущееОкно.ПолучитьКомандныйИнтерфейс();
	Для Каждого ТекКнопка Из КомандныйИнтерфейс.НайтиОбъекты(Тип("ТестируемаяКнопкаКомандногоИнтерфейса")) Цикл
		
		ТекКнопка.Нажать();
		
		КонтекстЯдра.Плагин("ТестКлиенты").ИдентифицироватьОкноПредупреждение(
			ТестКлиент,
			КонтекстЯдра.СтрШаблон_("Командный интерфейс формы: ""%1""", ТекКнопка.ТекстЗаголовка),
			Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПереходПоКнопкеКомандногоИнтерфейса()
	
	Возврат "Переход по кнопке командного интерфейса";
	
КонецФункции

&НаКлиенте
Функция КликПоПервойСтрокеТаблицыФормы()
	
	Возврат "Клик по первой строке таблицы формы";
	
КонецФункции

&НаКлиенте
Функция КликПоПоследнейСтрокеТаблицыФормы()
	
	Возврат "Клик по последней строке таблицы формы";
	
КонецФункции
