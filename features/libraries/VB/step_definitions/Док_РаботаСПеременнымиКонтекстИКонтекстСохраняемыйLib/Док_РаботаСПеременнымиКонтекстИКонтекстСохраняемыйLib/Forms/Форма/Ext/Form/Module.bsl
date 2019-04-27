﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

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
	//пример вызова Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯУбедилсяЧтоСлужебныйEPFДляПроверкиРаботыСПеременнымиКонтекстУдален()","ЯУбедилсяЧтоСлужебныйEPFДляПроверкиРаботыСПеременнымиКонтекстУдален","Дано Я убедился что служебный EPF для проверки работы с переменными Контекст удален");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯПерехожуВнутрьСвернутойПроцедуры()","ЯПерехожуВнутрьСвернутойПроцедуры","И я перехожу внутрь свернутой процедуры");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯЗаменяюСтрокуНа(Парам01,Парам02)","ЯЗаменяюСтрокуНа","И я заменяю строку ""ВызватьИсключение"" на ""//ВызватьИсключение""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯПерехожуВнутрьПроцедуры(Парам01)","ЯПерехожуВнутрьПроцедуры","И я перехожу внутрь процедуры ""ЯУказалПервоеСлагаемое""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯНажимаюНаКнопкуВыполнитьСценарии()","ЯНажимаюНаКнопкуВыполнитьСценарии","И     Я нажимаю на кнопку Выполнить Сценарии");

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
//Дано Я убедился что служебный EPF для проверки работы с переменными Контекст удален
//@ЯУбедилсяЧтоСлужебныйEPFДляПроверкиРаботыСПеременнымиКонтекстУдален()
Процедура ЯУбедилсяЧтоСлужебныйEPFДляПроверкиРаботыСПеременнымиКонтекстУдален() Экспорт
	ИмяEPF = Ванесса.Объект.КаталогИнструментов + "\features\Support\Instructions\Core\step_definitions\ДляРаботыСПеременнымиКонтекст.epf";
	Если Ванесса.ФайлСуществуетКомандаСистемы(ИмяEPF) Тогда
		Ванесса.УдалитьФайлыКомандаСистемы(ИмяEPF);
	КонецЕсли;

	Контекст.Вставить("ИмяEPF",ИмяEPF);

КонецПроцедуры

&НаКлиенте
//И я перехожу внутрь свернутой процедуры
//@ЯПерехожуВнутрьСвернутойПроцедуры()
Процедура ЯПерехожуВнутрьСвернутойПроцедуры() Экспорт
	ВызватьИсключение "Не реализовано.";
КонецПроцедуры

&НаКлиенте
//И     Я нажимаю на кнопку Выполнить Сценарии
//@ЯНажимаюНаКнопкуВыполнитьСценарии()
Процедура ЯНажимаюНаКнопкуВыполнитьСценарии() Экспорт
	Результат = Ванесса.ВыполнитьSikuliСкрипт(Ванесса.Объект.КаталогИнструментов + "\tools\Sikuli\RunScenarios.sikuli");
	Ванесса.ПроверитьРавенство(Результат, 0 , "Произошло выполнение скрипта <RunScenarios>");
КонецПроцедуры

&НаКлиенте
//И я заменяю строку "ВызватьИсключение" на "//ВызватьИсключение"
//@ЯЗаменяюСтрокуНа(Парам01,Парам02)
Процедура ЯЗаменяюСтрокуНа(ИсходнаяСтрока,Замена) Экспорт
	Результат = Ванесса.ВыполнитьSikuliСкрипт(Ванесса.Объект.КаталогИнструментов + "\tools\Sikuli\CtrlH.sikuli");
	Ванесса.ПроверитьРавенство(Результат, 0 , "Произошло выполнение скрипта <CtrlH>");

	Ванесса.Шаг("И я набираю текст '" + ИсходнаяСтрока + "'");

	Результат = Ванесса.ВыполнитьSikuliСкрипт(Ванесса.Объект.КаталогИнструментов + "\tools\Sikuli\PressTab.sikuli");
	Ванесса.ПроверитьРавенство(Результат, 0 , "Произошло выполнение скрипта <PressTab>");

	Ванесса.Шаг("И я набираю текст '" + Замена + "'");

	Результат = Ванесса.ВыполнитьSikuliСкрипт(Ванесса.Объект.КаталогИнструментов + "\tools\Sikuli\DoReplace.sikuli");
	Ванесса.ПроверитьРавенство(Результат, 0 , "Произошло выполнение скрипта <DoReplace>");

КонецПроцедуры

&НаКлиенте
//И я перехожу внутрь процедуры "ЯУказалПервоеСлагаемое"
//@ЯПерехожуВнутрьПроцедуры(Парам01)
Процедура ЯПерехожуВнутрьПроцедуры(Стр) Экспорт
	Результат = Ванесса.ВыполнитьSikuliСкрипт(Ванесса.Объект.КаталогИнструментов + "\tools\Sikuli\CtrlF.sikuli");
	Ванесса.ПроверитьРавенство(Результат, 0 , "Произошло выполнение скрипта <CtrlF>");

	Ванесса.Шаг("И я набираю текст 'Процедура " + Стр + "'");

	Ванесса.Шаг("И я набираю текст ""#enter""");

	Результат = Ванесса.ВыполнитьSikuliСкрипт(Ванесса.Объект.КаталогИнструментов + "\tools\Sikuli\CtrlPlus.sikuli");
	Ванесса.ПроверитьРавенство(Результат, 0 , "Произошло выполнение скрипта <CtrlPlus>");


	Результат = Ванесса.ВыполнитьSikuliСкрипт(Ванесса.Объект.КаталогИнструментов + "\tools\Sikuli\PressEndEnter.sikuli");
	Ванесса.ПроверитьРавенство(Результат, 0 , "Произошло выполнение скрипта <PressEndEnter>");
КонецПроцедуры
