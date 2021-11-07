//
//  ConsoleView.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import SwiftUI



struct ConsoleView: View {
    
    @ObservedObject var viewModel: ConsoleViewModel = ConsoleViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                VStack(spacing: 12) {
                    searchBarView()
                    
                    if viewModel.shouldShowMarkers {
                        markersView()
                    }
                    
                    logLevelsView()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Palette.frame)
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                .mask(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight]))
            }
            .padding(.horizontal, 10)
            .background(.clear)
            .zIndex(1)
            
            if viewModel.items.isEmpty {
                emptyContenerView()
            } else {
                // Console items collection
                contentView()
            }
        }
        .background(Palette.main)
        .edgesIgnoringSafeArea(.top)
    }
    
    @ViewBuilder
    func searchBarView() -> some View {
        HStack {
            SearchBar(text: $viewModel.searchText)
            if viewModel.markerToggleViewModels.count > 1 {
                VStack {
                    Button(action: {
                        viewModel.updateButtonState(shouldShowMarkers: !viewModel.shouldShowMarkers)
                    }, label: {
                        Image(systemName: viewModel.shouldShowMarkers ? "bookmark.circle.fill" : "bookmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(5)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            VStack {
                Button(action: {
                    viewModel.trashButtonPressed()
                }, label: {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 19, height: 19)
                        .padding(5)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }.padding(.top, 8)
    }
    
    @ViewBuilder
    func markersView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.markerToggleViewModels) { marker in
                    Button(action: {
                        viewModel.updateMarkerSelection(id: marker.id, value: !marker.isOn)
                    }) {
                        Text(marker.id)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 50)
                            .contentShape(Rectangle())
                            .foregroundColor(.white)
                            .font(.museoCyrl(.regular, size: 13))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, maxHeight: 22)
                    .background(marker.isOn ? Palette.buttonSelection : .clear)
                    .cornerRadius(5)
                }
            }
        }
    }
    
    @ViewBuilder
    func logLevelsView() -> some View {
        HStack(spacing: 12) {
            ForEach(viewModel.logLevelFilters) { item in
                Button(action: {
                    viewModel.updateLogLevelSelection(id: item.id, value: !item.isOn)
                }) {
                    Text(item.title)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .foregroundColor(item.color)
                        .font(.museoCyrl(.bold, size: 13))
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, maxHeight: 22)
                .background(item.isOn ? Palette.buttonSelection : .clear)
                .cornerRadius(5)
            }
        }
    }
    
    @ViewBuilder
    func emptyContenerView() -> some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 65, height: 65)
            Text("Server did not recieve any messages.\nCheck connection, please...")
                .multilineTextAlignment(.center)
                .font(.museoCyrl(.medium, size: 15))
            Spacer()
        }
        .padding(.top, 80)
        .zIndex(0)
    }
    
    @ViewBuilder
    func contentView() -> some View {
        ScrollView(showsIndicators: false) {
            Rectangle()
                .frame(height: viewModel.shouldShowMarkers ? 115 : 80)
                .foregroundColor(.clear)
            VStack(spacing: 0) {
                ForEach(viewModel.items.indices, id: \.self) { index in
                    let item = viewModel.items[index]

                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.color)
                            .frame(width: 4)
                        VStack(alignment: .leading, spacing: 0) {
                            if !item.markers.isEmpty {
                                HStack(spacing: 4) {
                                    ForEach(item.markers, id: \.self) { marker in
                                        Text(marker.uppercased())
                                            .padding(.horizontal, 3)
                                            .padding(.top, 2)
                                            .font(.circe(.bold, size: 10))
                                            .background(Palette.Row.markerBackground)
                                            .cornerRadius(2)
                                    }
                                    Spacer()
                                    Text(item.dateString)
                                        .font(.circe(.regular, size: 12))
                                        .foregroundColor(Palette.Row.title)
                                }
                                .padding(.bottom, 2)
                            }
                            HStack(alignment: .top, spacing: 4) {
                                VStack {
                                    Button(action: {
                                        viewModel.collapseItem(id: item.id)
                                    }, label: {
                                        Image(systemName: item.isExpanded ? "chevron.down" : "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 9, height: 9)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.top, 6)
                                }
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(item.title)
                                        .font(.circe(.regular, size: 14))
                                        .foregroundColor(Palette.Row.title)
                                        .textSelection(.enabled)
                                        .lineLimit(item.isExpanded ?  nil : 1)
                                }
                            }
                            if let jsonText = item.jsonFormattedMessage, !item.collapseItems.isEmpty, item.isExpanded {
                                HStack(alignment: .top, spacing: 4) {
                                    VStack(spacing: 4) {
                                        ForEach(item.collapseItems, id: \.id) { collapseItem in
                                            Button(action: {
                                                viewModel.collapseJsonContainer(itemID: item.id, collpaseItemID: collapseItem.id)
                                            }, label: {
                                                Image(systemName: collapseItem.isExpanded ? "chevron.down" : "chevron.right")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 9, height: 9)
                                            })
                                            .allowsHitTesting(collapseItem.isCollapsable)
                                            .opacity(collapseItem.isCollapsable ? 1 : 0)
                                            .buttonStyle(PlainButtonStyle())
                                            .padding(.top, 6)
                                        }
                                    }
                                    Text(jsonText)
                                        .font(.circe(.regular, size: 13))
                                        .foregroundColor(Palette.Row.subtitle)
                                        .fixedSize()
                                        .lineLimit(nil)
                                        .textSelection(.enabled)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .background(index % 2 == 0 ? Palette.Row.darkBackground : Palette.Row.lightBackground)
                }
            }
        }
        .padding(.top, 0)
        .zIndex(0)
    }
}
