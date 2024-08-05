//
//  TodoListViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct Todo {
    var title: String
    var isChecked: Bool
}

class TodoListViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TODO LIST"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let todoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "해야할 일을 적어보세요"
        return textField
    }()
    
    private let addTodoButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
        tableView.rowHeight = 50
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    let todoListRelay = BehaviorRelay<[Todo]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBind()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [titleLabel, todoTextField, addTodoButton, tableView].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        todoTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        addTodoButton.snp.makeConstraints { make in
            make.top.equalTo(todoTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addTodoButton.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupBind() {
        // 테이블뷰
        todoListRelay
            .bind(to: tableView.rx.items(cellIdentifier: "TodoTableViewCell", cellType: TodoTableViewCell.self)) { (row, todo, cell) in
                cell.configure(with: todo)
                cell.checkboxButton.rx.tap
                    .map { Todo(title: todo.title, isChecked: !todo.isChecked) }
                    .subscribe(onNext: { [weak self] updatedTodo in
                        self?.updateTodo(at: row, with: updatedTodo)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // todo 추가
        addTodoButton.rx.tap
            .withLatestFrom(todoTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .map { Todo(title: $0, isChecked: false) }
            .subscribe(onNext: { [weak self] newTodo in
                self?.addTodo(newTodo)
                self?.todoTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        // 삭제
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.removeTodo(at: indexPath.row)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func addTodo(_ todo: Todo) {
        var currentTodos = todoListRelay.value
        currentTodos.append(todo)
        todoListRelay.accept(currentTodos)
    }
    
    func removeTodo(at index: Int) {
        var currentTodos = todoListRelay.value
        currentTodos.remove(at: index)
        todoListRelay.accept(currentTodos)
    }
    
    func updateTodo(at index: Int, with updatedTodo: Todo) {
        var currentTodos = todoListRelay.value
        currentTodos[index] = updatedTodo
        todoListRelay.accept(currentTodos)
    }
}

class TodoTableViewCell: UITableViewCell {
    
    let checkboxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let todoLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        [checkboxButton, todoLabel].forEach { contentView.addSubview($0) }
        
        checkboxButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        todoLabel.snp.makeConstraints { make in
            make.left.equalTo(checkboxButton.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with todo: Todo) {
        todoLabel.text = todo.title
        let image = todo.isChecked ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        checkboxButton.setImage(image, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
