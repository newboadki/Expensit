//
//  EntryFormView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct EntryFormView: View {
    
    @ObservedObject private var presenter: EntryFormPresenter
    @State var isCategoryPickerExpanded: Bool = false
    @State var isDatePickerExpanded: Bool = false
    @Binding var isPresented: Bool
    
    init(presenter: EntryFormPresenter, beingPresented: Binding<Bool>) {
        self.presenter = presenter
        self._isPresented = beingPresented
        UITableView.appearance().separatorStyle = .none
    }
        
    var body: some View {
                
        return NavigationView {
            List {
                Section {
                    TextField("Amount", text: amountBinding())
                    TextField("Description", text: descBinding())
                }

                Section {
                    CategoryPickerView(isExpanded: isCategoryPickerExpanded,
                                       categories: presenter.categories,
                                       selectedIndex: categoryBinding())
                        .onTapGesture { self.isCategoryPickerExpanded = !self.isCategoryPickerExpanded }
                        .animation(.linear(duration: 0.3))                    
                }

                Section {
                    DatePickerView(isExpanded: isDatePickerExpanded, date: dateBinding())
                        .onTapGesture { self.isDatePickerExpanded = !self.isDatePickerExpanded }
                        .animation(.linear(duration: 0.3))
                }
                
            }.navigationBarItems(trailing:
                Button("Save") {
                    self.presenter.handleSaveButtonPressed()
                    self.$isPresented.wrappedValue = false
                }
            )
        }
    }
}

// MARKS: - Bindings
private extension EntryFormView {
    func amountBinding() -> Binding<String> {
        return Binding<String>(
            get: {
                self.presenter.entry.value ?? ""
            },
            set: {
                self.presenter.entry.value = $0
            }
        )
    }
    
    func descBinding() -> Binding<String> {
        return Binding<String>(
            get: {
                self.presenter.entry.desc ?? ""
            },
            set: {
                self.presenter.entry.desc = $0
            }
        )
    }
        
    func categoryBinding() -> Binding<Int> {
        return Binding<Int>(
            get: {
                self.presenter.entry.tagId
            },
            set: {
                self.presenter.entry.tagId = $0
            }
        )
    }
        
    func dateBinding() -> Binding<Date> {
        return Binding<Date>(
            get: {
                self.presenter.entry.dateTime
            },
            set: {
                self.presenter.entry.dateTime = $0
            }
        )
    }
}

//struct EntryFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryFormView(presenter: EntryFormPresenter(storageInteractor: <#BSAddEntryController#>))
//    }
//}
