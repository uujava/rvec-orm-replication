menu do
	name 'Расширения'
	menu do
		name 'Компоненты'
		menuitem do
			name 'Основной'
			icon 'vcs_tree_icon.png'
			editor :'Компоненты'
		end
		separator
		menu do
			name 'Справочники'
			menuitem do
				name 'Ведение данных'
				action %q/
                         $CONTROL.start_application('DirRef_A_Main_UseExample')
                    /
				icon 'jrDialog.png'
			end
			separator
			menuitem do
				name 'Проверка целостности'
				icon 'red_16x16.png'
				action %q/
                    $space.event_service.publish StatusEvent.new "Начинаю процесс проверки целостности данных компонента ведения справочника."
                    result=User::КомпонентСправочник.проверить_целостность_компонента
                    if result
                         puts result
                         $space.event_service.publish StatusEvent.new  "Закончен процесс проверки целостности данных компонента ведения справочника: список ошибок направлен на стандартный вывод."
                         User::UserObject.get_by_attr_val("name", "КомпонентСправочник", "H_Components").checked=false
                         User::UserObject.get_by_attr_val("name", "КомпонентСправочник", "H_Components").checkDate=Time.now
                    else
                         $space.event_service.publish StatusEvent.new  "Закончен процесс проверки целостности данных компонента ведения справочника: ошибок не обнаружено."
                         User::UserObject.get_by_attr_val("name", "КомпонентСправочник", "H_Components").checked=true
                         User::UserObject.get_by_attr_val("name", "КомпонентСправочник", "H_Components").checkDate=Time.now
                    end
                    /
			end
		end
		separator
		menu do
			name 'Паспортизация'
			menuitem do
				name 'Ведение данных'
				editor :'Паспортные данные'
				icon 'jrDialog.png'
			end
			separator
			menuitem do
				name 'Проверка целостности'
				icon 'red_16x16.png'
				action %q/
                    $space.event_service.publish StatusEvent.new "Начинаю процесс проверки целостности данных компонента ведения паспортных данных."
                    result=User::ТиповойПаспортОбъекта.проверить_целостность_компонента
                    if result
                         puts result
                         $space.event_service.publish StatusEvent.new  "Закончен процесс проверки целостности данных компонента ведения паспортных данных: список ошибок направлен на стандартный вывод."
                         User::UserObject.get_by_attr_val("name", "КомпонентПаспортизация", "H_Components").checked=false
                         User::UserObject.get_by_attr_val("name", "КомпонентПаспортизация", "H_Components").checkDate=Time.now
                    else
                         $space.event_service.publish StatusEvent.new  "Закончен процесс проверки целостности данных компонента ведения паспортных данных: ошибок не обнаружено."
                         User::UserObject.get_by_attr_val("name", "КомпонентПаспортизация", "H_Components").checked=true
                         User::UserObject.get_by_attr_val("name", "КомпонентПаспортизация", "H_Components").checkDate=Time.now
                    end
                    /
			end
		end
		separator
		menu do
			name 'Стили'
			menuitem do
				name 'Справка'
				editor :StylesExample
				icon 'onLamp16.png'
			end
			menuitem do
				name 'Редактор стилей'
				editor :'СтилиАдмин'
				icon 'jrColorField.png'
			end
		end
		separator
		menuitem do
			name 'Сообщения'
		end
		separator
		menuitem do
			name 'Приказы'
			editor :'АдминПриказы'
			icon 'diagona/16/046.png.png'
		end
		separator
		menuitem do
			name 'Очередь заданий'
			editor :Shedule_sc
			icon 'diagona/16/082.png'
		end
	end
	menuitem do
		name 'Онтология'
		icon 'console.png'
		editor :Ontology_Viewer_Sc
	end
	menuitem do
		name 'Редактор онтологии'
		icon 'parents.gif'
		action %q/
               $CONTROL.start_application('Ontology_All_Entity')
           /
	end
	menu do
		name 'Прикладной администратор'
		menuitem do
			name 'Реестры'
			icon 'console.png'
			action %q/
                    $CONTROL.start_application('АРМ_Прикладного_Администратора')
               /
		end
		menuitem do
			name 'Проверка расписания'
			icon 'red_16x16.png'
			action %q/
                    $CONTROL.start_application('ARM_PA_Shedule_Troubles')
               /
		end
		menuitem do
			name 'Проверка инфраструктуры'
			icon 'red_16x16.png'
			action %q/
                    $CONTROL.start_application('ARM_PA_Infrastructure_Troubles')
               /
		end
	end
end
