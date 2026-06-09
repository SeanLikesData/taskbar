import SwiftUI

/// The top row: the week picker with completion count, a New Week button, and
/// a delete-week button.
struct TopBar: View {
    @EnvironmentObject var store: WeekStore
    @State private var confirmingDelete = false

    var body: some View {
        HStack(spacing: 12) {
            weekPicker
            Button(action: { store.addNewWeek() }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("New Week")
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Style.primaryText)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Capsule().fill(Style.chipFill))
                .overlay(Capsule().strokeBorder(Style.divider, lineWidth: 1))
            }
            .buttonStyle(.plain)

            Button(role: .destructive, action: { confirmingDelete = true }) {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundColor(Style.secondaryText)
                    .padding(9)
                    .background(Capsule().fill(Style.chipFill))
                    .overlay(Capsule().strokeBorder(Style.divider, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .help("Delete this week")
            .confirmationDialog("Delete this week?", isPresented: $confirmingDelete) {
                Button("Delete Week", role: .destructive) { store.deleteCurrentWeek() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This removes the week and all of its tasks.")
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private var weekPicker: some View {
        Menu {
            ForEach(store.weeksSorted) { week in
                Button {
                    store.selectedWeekID = week.id
                    store.activeDay = .monday
                    store.region = .thisWeek
                    store.selectedID = store.orderedIDs(for: .thisWeek).first
                } label: {
                    let counts = week.completion
                    Text("\(WeekMath.weekLabel(for: week.weekStart))  ·  \(counts.done)/\(counts.total)")
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Style.primaryText)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Style.secondaryText)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(Capsule().fill(Style.chipFill))
            .overlay(Capsule().strokeBorder(Style.divider, lineWidth: 1))
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .fixedSize()
    }

    private var label: String {
        guard let week = store.currentWeek else { return "No week" }
        let counts = week.completion
        return "\(WeekMath.weekLabel(for: week.weekStart))  ·  \(counts.done)/\(counts.total)"
    }
}
