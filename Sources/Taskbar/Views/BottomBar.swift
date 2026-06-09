import SwiftUI

/// The bottom bar: saved-week count on the left; save status, Template, help,
/// and settings on the right.
struct BottomBar: View {
    @EnvironmentObject var store: WeekStore

    var body: some View {
        HStack(spacing: 10) {
            Text("\(store.savedWeekCount) saved week\(store.savedWeekCount == 1 ? "" : "s")")
                .font(.system(size: 12))
                .foregroundColor(Style.mutedText)

            Spacer()

            Text(store.saveStateLabel)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Style.secondaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Capsule().fill(Style.chipFill))

            iconButton(systemName: "square.grid.2x2", title: "Template") {
                store.activeSheet = .template
            }

            iconButton(systemName: "questionmark", title: nil) {
                store.activeSheet = .help
            }

            iconButton(systemName: "gearshape", title: nil) {
                store.activeSheet = .settings
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private func iconButton(systemName: String, title: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: systemName)
                    .font(.system(size: 13, weight: .medium))
                if let title {
                    Text(title)
                        .font(.system(size: 13, weight: .medium))
                }
            }
            .foregroundColor(Style.primaryText)
            .padding(.horizontal, title == nil ? 9 : 12)
            .padding(.vertical, 7)
            .background(Capsule().fill(Style.chipFill))
            .overlay(Capsule().strokeBorder(Style.divider, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

extension WeekStore {
    var saveStateLabel: String {
        switch saveState {
        case .saved: return "Saved"
        case .saving: return "Saving…"
        }
    }
}
