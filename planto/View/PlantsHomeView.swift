//
//  PlantsHomeView.swift
//  PlanTo
//
//  الشاشة الرئيسية "My Plants 🌱". تتغير حسب الحالة (من Sketch):
//   - empty       ← "Start your plant journey!"  مع زر Set Plant Reminder (أول مرة بس)
//   - noReminders ← "No reminders set yet.."     مع زر +
//   - list    ← "Today Reminder"             الشريط + قائمة النباتات + زر +
//   - allDone ← "All Done! 🎉"               مع زر +
//

import SwiftUI

struct PlantsHomeView: View {

    // الـ ViewModel (الطباخ). @State = الشاشة هي اللي تملكه وتحتفظ فيه
    @State private var viewModel: PlantsViewModel

    // نعطي الشاشة الـ ViewModel من برا:
    // في التطبيق ← الحقيقي (تلقائياً)، وفي الـ Preview ← اللي فيه نباتات تجريبية
    init(viewModel: PlantsViewModel = PlantsViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    // ---- الفورم ----
    @State private var showForm = false          // هل الفورم مفتوح؟
    @State private var plantToEdit: Plant?       // nil = نبتة جديدة،  غير كذا = نعدّلها

    // نفتح الفورم لنبتة جديدة
    private func openAddForm() {
        plantToEdit = nil
        showForm = true
    }

    // نفتح الفورم لتعديل نبتة
    private func openEditForm(_ plant: Plant) {
        plantToEdit = plant
        showForm = true
    }

    var body: some View {
        // ZStack = فوق بعض: المحتوى تحت، وزر + فوقه في الزاوية
        ZStack(alignment: .bottomTrailing) {

            // ---- المحتوى ----
            VStack(alignment: .leading, spacing: 0) {
                header                      // "My Plants 🌱" والخط تحته

                // switch = نختار وش نعرض حسب حالة الـ ViewModel
                switch viewModel.state {
                case .empty:       emptyContent
                case .noReminders: noRemindersContent
                case .list:    listContent
                case .allDone: allDoneContent
                }
            }

            // ---- زر + (يطلع في القائمة و All Done بس، مثل Sketch) ----
            if viewModel.state != .empty {
                CircleButton(icon: AppIcons.add) {
                    openAddForm()                       // يفتح فورم Set Reminder
                }
                .padding(.trailing, 30)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())   // خلفية سودا لكل الشاشة
        // الـ Sheet: يطلع من تحت لما showForm = true
        .sheet(isPresented: $showForm) {
            PlantFormSheet(
                plantToEdit: plantToEdit,
                onSave: { plant in
                    // إذا نعدّل ← edit، إذا جديدة ← add
                    if plantToEdit == nil {
                        viewModel.add(plant)
                    } else {
                        viewModel.edit(plant)
                    }
                },
                onDelete: {
                    if let plant = plantToEdit { viewModel.delete(plant) }
                }
            )
            .presentationCornerRadius(AppLayout.sheetRadius)     // زوايا 39 (من Sketch)
        }
    }


    // MARK: - العنوان (يتكرر في كل الحالات)

    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("My Plants 🌱")
                .font(.screenTitle)                 // 34 Bold
                .foregroundColor(.textPrimary)
                .padding(.leading, 16)

            Rectangle()                             // الخط الرفيع تحت العنوان
                .fill(Color.headerDivider)
                .frame(height: 1)
                .padding(.leading, 15)
        }
        .padding(.top, 30)
    }


    // MARK: - الحالة ١: ما فيه نباتات

    private var emptyContent: some View {
        VStack(spacing: 0) {
            Spacer()
            EmptyStateView(imageName: "plantHappy",
                           title: "Start your plant journey!",
                           subtitle: "Now all your plants will be in one place and we will help you take care of them :) 🪴")
            Spacer()
            PrimaryButton(title: "Set Plant Reminder") {
                viewModel.markStarted()                 // خلاص صار مو مستخدم جديد
                openAddForm()                           // يفتح فورم Set Reminder
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }


    // MARK: - الحالة ١.٥: بدأ قبل بس ما عنده نباتات (من Sketch: "No reminders")

    private var noRemindersContent: some View {
        VStack {
            Spacer()
            Text("No reminders set yet..")
                .font(.emptyTitle)                  // 20 Semibold
                .foregroundColor(.textEmpty)        // #756F6F
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }


    // MARK: - الحالة ٢: قائمة النباتات

    private var listContent: some View {
        VStack(spacing: 0) {
            // الجملة والشريط، والقيم كلها جاية من الـ ViewModel
            ProgressHeader(text: viewModel.progressText,
                           progress: viewModel.progress)
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.bottom, 40)

            // List = قائمة نقدر نسوي فيها swipe للحذف
            List {
                // ForEach = يكرر PlantRow لكل نبتة (هنا يفيد Identifiable)
                ForEach(viewModel.sortedPlants) { plant in
                    PlantRow(plant: plant) {
                        viewModel.toggleWatered(plant)          // الدائرة ○ ✓
                    }
                    .contentShape(Rectangle())                  // الصف كله ينضغط
                    .onTapGesture { openEditForm(plant) }       // الضغط على الصف = تعديل
                    // شكل الصف: بدون خلفية ولا خطوط افتراضية (الخط عندنا داخل PlantRow)
                    .listRowBackground(Color.appBackground)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    // swipe للحذف: زر أحمر فيه سلة (من Sketch)
                    .swipeActions(edge: .trailing) {
                        Button {
                            viewModel.delete(plant)
                        } label: {
                            Image(systemName: AppIcons.delete)
                        }
                        .tint(.destructiveRed)
                    }
                }
            }
            .listStyle(.plain)                    // قائمة بسيطة بدون إطارات
            .scrollContentBackground(.hidden)     // نخفي خلفية القائمة الافتراضية
            // أنيميشن: لما نبتة تنسقى وتنزل تحت، تتحرك بنعومة
            .animation(.easeInOut, value: viewModel.sortedPlants.map(\.id))
        }
    }


    // MARK: - الحالة ٣: كل النباتات انسقت

    private var allDoneContent: some View {
        VStack {
            Spacer()
            EmptyStateView(imageName: "plantWink",
                           title: "All Done! 🎉",
                           subtitle: "All Reminders Completed",
                           showsCircle: true)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// معاينة بالنباتات التجريبية (Monstera, Pothos, Orchid, Spider)
#Preview("Plants") {
    PlantsHomeView(viewModel: PlantsViewModel(store: PreviewPlantStore(), notifications: PreviewNotificationService()))
}

// معاينة الشاشة الفاضية
#Preview("Empty") {
    PlantsHomeView(viewModel: PlantsViewModel(store: PreviewPlantStore(plants: []), notifications: PreviewNotificationService()))
}
