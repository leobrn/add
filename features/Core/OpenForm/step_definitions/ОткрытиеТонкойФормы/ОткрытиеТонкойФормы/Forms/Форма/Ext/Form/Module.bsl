﻿//начало текста модуля
&НаКлиенте
Перем Ванесса;

&НаКлиенте
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;

	ВсеТесты = Новый Массив;

	//пример вызова Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯРаботаюСVanessa_ADDepf()","ЯРаботаюСVanessa_ADDepf","я работаю с bddRunner.epf");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯРаботаюСbddRunnerepf()","ЯРаботаюСVanessa_ADDepf","я работаю с bddRunner.epf");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯМогуОткрытьФормуОбработки()","ЯМогуОткрытьФормуОбработки","я могу открыть форму обработки");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯМогуЗакрытьФормуОбработки()","ЯМогуЗакрытьФормуОбработки","я могу закрыть форму обработки");

	Возврат ВсеТесты;
КонецФункции

&НаКлиенте
Процедура ПередНачаломСценария() Экспорт

КонецПроцедуры

&НаКлиенте
Процедура ПередОкончаниемСценария() Экспорт

КонецПроцедуры


&НаКлиенте
//я работаю с bddRunner.epf
//@ЯРаботаюСVanessa_ADDepf()
Процедура ЯРаботаюСVanessa_ADDepf() Экспорт
	ПутьКОбработке = Ванесса.Объект.КаталогИнструментов + "\bddRunner.epf";

	Контекст.Вставить("ПутьКОбработке",ПутьКОбработке);
КонецПроцедуры

&НаКлиенте
//я могу открыть форму обработки
//@ЯМогуОткрытьФормуОбработки()
Процедура ЯМогуОткрытьФормуОбработки() Экспорт
	ИмяОбработки = Ванесса.ПодключитьВнешнююОбработкуКлиент(Контекст.ПутьКОбработке);
	ФормаОбработки = ПолучитьФорму("ВнешняяОбработка." + ИмяОбработки + ".Форма.УправляемаяФорма",,,Истина);
	Ванесса.ПроверитьНеРавенство(ФормаОбработки.Открыта(),Истина,"Форма обработки должна быть закрыта.");

	ФормаОбработки.Объект.РежимСамотестирования = Истина;
	ФормаОбработки.Открыть();

	Ванесса.ПроверитьРавенство(ФормаОбработки.Открыта(),Истина,"Форма обработки должна открыться.");

	Контекст.Вставить("ФормаОбработки",ФормаОбработки);
КонецПроцедуры

&НаКлиенте
//я могу закрыть форму обработки
//@ЯМогуЗакрытьФормуОбработки()
Процедура ЯМогуЗакрытьФормуОбработки() Экспорт
	ФормаОбработки = Контекст.ФормаОбработки;
	ФормаОбработки.Закрыть();

	Ванесса.ПроверитьРавенство(ФормаОбработки.Открыта(),Ложь,"Форма обработки должна закрыться.");
КонецПроцедуры

//окончание текста модуля