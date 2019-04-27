﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-ADD
Перем Ванесса;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;

	ВсеТесты = Новый Массив;

	//описание параметров
	//пример вызова Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯДобавляюВПеременнуюКонтекстЗначениеСоЗначением(Парам01,Парам02)","ЯДобавляюВПеременнуюКонтекстЗначениеСоЗначением","Когда я добавляю в переменную Контекст значение ""СлужебнаяПеременная"" со значением 0");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯДобавляюВПеременнойКонтекстаЗначение(Парам01,Парам02)","ЯДобавляюВПеременнойКонтекстаЗначение","И я добавляю в переменной контекста ""СлужебнаяПеременная"" значение 1");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВМетодеШагЯВыполняюСтроку(Парам01)","ВМетодеШагЯВыполняюСтроку","И в методе Шаг я выполняю строку 'И я добавляю в переменной контекста ""СлужебнаяПеременная"" значение 1'");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВПеременнойКонтекстБудетЛежатьЗначение(Парам01,Парам02)","ВПеременнойКонтекстБудетЛежатьЗначение","Тогда в переменной Контекст ""СлужебнаяПеременная"" будет лежать значение 2");

	Возврат ВсеТесты;
КонецФункции

&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	Возврат ПолучитьМакет(ИмяМакета);
КонецФункции

&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт

КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт

КонецПроцедуры



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Когда я добавляю в переменную Контекст значение "СлужебнаяПеременная" со значением 0
//@ЯДобавляюВПеременнуюКонтекстЗначениеСоЗначением(Парам01,Парам02)
Процедура ЯДобавляюВПеременнуюКонтекстЗначениеСоЗначением(ИмяПеременной,ЗначениеПеременной) Экспорт
	Контекст.Вставить(ИмяПеременной,ЗначениеПеременной);
КонецПроцедуры

&НаКлиенте
//И я добавляю в переменной контекста "СлужебнаяПеременная" значение 1
//@ЯДобавляюВПеременнойКонтекстаЗначение(Парам01,Парам02)
Процедура ЯДобавляюВПеременнойКонтекстаЗначение(ИмяПеременной,Значение) Экспорт
	Контекст[ИмяПеременной] = Контекст[ИмяПеременной] + Значение;
КонецПроцедуры

&НаКлиенте
//И в методе Шаг я выполняю строку 'И я добавляю в переменной контекста "СлужебнаяПеременная" значение 1'
//@ВМетодеШагЯВыполняюСтроку(Парам01)
Процедура ВМетодеШагЯВыполняюСтроку(СтрокаШага) Экспорт

	Ванесса.Шаг(СтрокаШага);
КонецПроцедуры

&НаКлиенте
//Тогда в переменной Контекст "СлужебнаяПеременная" будет лежать значение 2
//@ВПеременнойКонтекстБудетЛежатьЗначение(Парам01,Парам02)
Процедура ВПеременнойКонтекстБудетЛежатьЗначение(ИмяПеременной,ЗначениеПеременной) Экспорт
	Если Контекст[ИмяПеременной] <> ЗначениеПеременной Тогда
		ВызватьИсключение "Переменная контекста " + ИмяПеременной + " равна " + Контекст[ИмяПеременной] + ", а ожидали " + ЗначениеПеременной;
	КонецЕсли;
КонецПроцедуры

//окончание текста модуля