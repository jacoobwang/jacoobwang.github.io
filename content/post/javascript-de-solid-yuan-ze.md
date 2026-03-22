---
title: "JavaScript 的 SOLID 原则"
date: 2018-12-13T00:00:00+08:00
draft: false
description: "详解 SOLID 原则在 JavaScript 中的应用，包括单一职责、开闭原则、里氏替换、接口隔离和依赖倒置"
---

SOLID 原则首先由著名的计算机科学家 Robert C·Martin （著名的Bob大叔）由 2000 年在他的论文中提出。但是 SOLID 缩略词是稍晚由 Michael Feathers 先使用的。

Bob大叔也是畅销书《代码整洁之道》和《架构整洁之道》的作者，也是 "Agile Alliance" 的成员。

SOLID 是一组原则的首字母缩写，包括：

- **S** 单一职责原则
- **O** 开闭原则
- **L** 里氏替换原则
- **I** 接口隔离原则
- **D** 依赖倒置原则

有助于软件工程师设计和编写可维护、可扩展和灵活的代码。其目的是什么呢？是为了提高遵循面向对象编程（OOP）范式开发的软件质量。

## 单一职责原则（SRP）

SOLID 中的第一个字母代表单一职责原则。该原则建议一个类或模块应该只执行一个功能。如果一个类处理多个功能，那么在不影响其他功能的情况下更新一个功能就会变得棘手。随之而来的复杂性可能会导致软件性能出现故障。为了避免这些问题，我们应尽力编写关注点分离的模块化软件。

如果一个类有太多的职责或功能，修改起来就会很头疼。通过使用单一职责原则，我们可以编写模块化、更易于维护且不易出错的代码。例如，以一个人员模型为例：

```javascript
class Person {
    constructor(name, age, height, country) {
        this.name = name;
        this.age = age;
        this.height = height;
        this.country = country;
    }

    getPersonCountry() {
        console.log(this.country);
    }

    greetPerson() {
        console.log("Hi " + this.name);
    }

    static calculateAge(dob) {
        const today = new Date();
        const birthDate = new Date(dob);

        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();

        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        return age;
    }
}
```

上面的代码看起来没问题，对吧？不完全是。示例代码违反了单一职责原则。Person类不仅仅是可以创建其他Person实例的唯一模型，它还有其他职责，如calculateAge、greetPerson和getPersonCountry。

Person类处理的这些额外职责使得仅更改代码的一个方面变得困难。例如，如果你试图重构calculateAge，可能还不得不重构Person模型。根据我们代码库的紧凑程度和复杂性，在不引发错误的情况下重新配置代码可能会很困难。

让我们尝试修正这个错误。我们可以将职责分离到不同的类中，如下所示：

```javascript
class Person {
    constructor(name, dateOfBirth, height, country) {
        this.name = name;
        this.dateOfBirth = dateOfBirth;
        this.height = height;
        this.country = country;
    }
}

class PersonUtils {
    static calculateAge(dob) {
        const today = new Date();
        const birthDate = new Date(dob);

        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();

        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        return age;
    }
}

const person = new Person("John", new Date(1994, 11, 23), "6ft", "USA");
console.log("Age: " + PersonUtils.calculateAge(person.dateOfBirth));

class PersonService {
    getPersonCountry() {
        console.log(this.country);
    }

    greetPerson() {
        console.log("Hi " + this.name);
    }
}
```

从上面的示例代码中可以看到，我们已经分离了职责。Person类现在是一个模型，我们可以用它创建新的人员对象。而PersonUtils类只有一个职责 —— 计算人员的年龄。PersonService类处理问候并显示每个人的国家。

如果愿意，我们还可以进一步简化这个过程。遵循单一职责原则，我们希望将类的职责解耦到最低限度，以便在出现问题时，可以轻松进行重构和调试。

通过将功能划分为单独的类，我们遵循了单一职责原则，并确保每个类负责应用程序的特定方面。

然而，遵循单一职责原则意味着我们应该有意地为类分配功能。一个类执行的所有操作在各个方面都应该密切相关。我们必须注意不要到处都是零散的多个类，并且在代码库中应尽量避免臃肿的类。

## 开闭原则（OCP）

开闭原则指出软件组件（类、函数、模块等）应该对扩展开放，对修改关闭。开闭原则只是要求软件的设计方式允许扩展，而不必修改源代码。

开闭原则对于维护大型代码库至关重要，因为这个准则允许你引入新功能，而几乎没有破坏代码的风险。当出现新需求时，不应修改现有类或模块，而应通过添加新组件来扩展相关类。在这样做时，一定要检查新组件不会给系统引入任何错误。

在 JavaScript 中，可以使用 ES6 + 的类继承特性来实现开闭原则。

以下代码片段说明了如何使用上述 ES6 + 的class关键字在 JavaScript 中实现开闭原则：

```javascript
class Rectangle {
    constructor(width, height) {
        this.width = width;
        this.height = height;
    }

    area() {
        return this.width * this.height;
    }
}

class ShapeProcessor {
    calculateArea(shape) {
        if (shape instanceof Rectangle) {
            return shape.area();
        }
    }
}

const rectangle = new Rectangle(10, 20);
const shapeProcessor = new ShapeProcessor();
console.log(shapeProcessor.calculateArea(rectangle));
```

上面的代码可以正常工作，但它仅限于计算矩形的面积。现在假设出现了一个新的计算需求。例如，我们需要计算圆形的面积。我们将不得不修改ShapeProcessor类来满足这个需求。然而，遵循 JavaScript ES6 + 标准，我们可以扩展这个功能以计算新形状的面积，而不必修改ShapeProcessor类。

```javascript
class Shape {
    area() {
        console.log("Override method area in subclass");
    }
}

class Rectangle extends Shape {
    constructor(width, height) {
        super();
        this.width = width;
        this.height = height;
    }

    area() {
        return this.width * this.height;
    }
}

class Circle extends Shape {
    constructor(radius) {
        super();
        this.radius = radius;
    }

    area() {
        return Math.PI * this.radius * this.radius;
    }
}

class ShapeProcessor {
    calculateArea(shape) {
        return shape.area();
    }
}

const rectangle = new Rectangle(20, 10);
const circle = new Circle(2);
const shapeProcessor = new ShapeProcessor();
console.log(shapeProcessor.calculateArea(rectangle));
console.log(shapeProcessor.calculateArea(circle));
```

在上面的代码片段中，我们使用extends关键字扩展了Shape类的功能。在每个子类中，我们重写了area()方法的实现。遵循这个原则，我们可以添加更多形状并计算面积，而无需修改ShapeProcessor类的功能。

### 为什么开闭原则很重要？

- **减少错误**：开闭原则通过避免系统修改来帮助避免大型代码库中的错误。
- **鼓励软件适应性**：开闭原则还提高了在不破坏或更改源代码的情况下向软件添加新功能的容易程度。
- **测试新功能**：开闭原则提倡代码扩展而不是修改，使得新功能可以作为一个单元进行测试，而不影响整个代码库。

## 里氏替换原则

里氏替换原则指出，子类的对象应该能够替换父类的对象而不破坏代码。让我们通过一个例子来解释它是如何工作的：如果L是P的子类，那么L的对象应该能够替换P的对象而不破坏系统。这仅仅意味着子类应该能够以不破坏系统的方式重写父类的方法。

在实践中，里氏替换原则确保遵循以下条件：

- 子类应该重写父类的方法而不破坏代码。
- 子类不应偏离父类的行为，这意味着子类只能添加功能，而不能更改或删除父类的功能。
- 使用父类实例的代码应该能够使用子类的实例，而无需知道类已经发生了变化。

是时候用 JavaScript 代码示例来说明里氏替换原则了。看一下：

```javascript
class Vehicle {
    OnEngine() {
        console.log("Engine is steaming!");
    }
}

class Car extends Vehicle {
    // 你可以调用超类的OnEngine方法并实现汽车发动机启动的方式
}

class Bicycle extends Vehicle {
    OnEngine() {
        throw new Error("Bicycles technically don't have an engine");
    }
}

const myCar = new Car();
const myBicycle = new Bicycle();
myCar.OnEngine();
myBicycle.OnEngine();
```

在上面的代码片段中，我们创建了两个子类（Bicycle和Car）和一个超类（Vehicle）。出于本文的目的，我们为超类实现了一个单一方法（OnEngine）。

里氏替换原则的一个核心条件是子类应该重写父类的功能而不破坏代码。记住这一点，让我们看看我们刚刚看到的代码片段是如何违反里氏替换原则的。实际上，汽车有发动机并且可以启动发动机，但自行车从技术上讲没有发动机，因此不能启动发动机。所以，Bicycle类不能在不破坏代码的情况下重写Vehicle类中的OnEngine方法。

我们现在已经确定了违反里氏替换原则的代码部分。Car类可以重写超类中的OnEngine功能，并以一种使其与其他车辆（例如飞机）区分开来的方式实现它，并且代码不会被破坏。Car类满足里氏替换原则。

在下面的代码片段中，我们将说明如何组织代码以符合里氏替换原则：

```javascript
class Vehicle {
    move() {
        console.log("The vehicle is moving.");
    }
}
```

这是一个具有基本功能move的Vehicle类的基本示例。一般认为所有车辆都能移动；它们只是通过不同的机制移动。我们将通过重写move()方法并以一种描绘特定车辆（例如汽车）如何移动的方式来实现它，以此来说明里氏替换原则。

为此，我们将创建一个Car类，它扩展Vehicle类并覆盖move方法以适应汽车的移动，如下所示：

```javascript
class Car extends Vehicle {
    move() {
        console.log("Car is running on four wheels");
    }
}
```

我们仍然可以在另一个子车辆类（例如飞机）中实现move方法。我们可以这样做：

```javascript
class Airplane extends Vehicle {
    move() {
        console.log("Airplane is flying...");
    }
}
```

在上面的两个示例中，我们说明了诸如继承和方法重写等关键概念。注意：允许子类实现已经在父类中定义的方法的编程特性称为方法重写。让我们进行一些整理并将所有内容放在一起，如下所示：

```javascript
class Vehicle {
    move() {
        console.log("The vehicle is moving.");
    }
}

class Car extends Vehicle {
    move() {
        console.log("Car is running on four wheels");
    }

    getSeatCapacity() {
    }
}

class Airplane extends Vehicle {
    move() {
        console.log("Airplane is flying...");
    }
}

const car = new Car();
const airplane = new Airplane();
car.move(); // 输出：Car is running on four wheels
```

现在，我们有两个子类继承并覆盖了父类的单个功能，并根据它们的需求实现了它。这个新的实现不会破坏代码。

## 接口隔离原则（ISP）

接口隔离原则指出，任何客户端都不应被迫依赖它不使用的接口。它希望我们创建更小、更具体的接口，这些接口与特定客户端相关，而不是有一个大的、单一的接口，迫使客户端实现他们不需要的方法。

保持接口紧凑使代码库更易于调试、维护、测试和扩展。如果没有接口隔离原则，大型接口的一部分发生变化可能会迫使代码库中不相关的部分发生变化，导致我们进行代码重构，在大多数情况下，根据代码库的大小，这可能是一项艰巨的任务。

与基于 C 的编程语言（如 Java）不同，JavaScript 没有内置的接口支持。然而，有一些技术可以在 JavaScript 中实现接口。

接口是一组类必须实现的方法签名。在 JavaScript 中，你可以将接口定义为一个包含方法和函数签名名称的对象，如下所示：

```javascript
const InterfaceA = {
    method: function () { }
}
```

要在 JavaScript 中实现接口，创建一个类并确保它包含与接口中指定的名称和签名相同的方法：

```javascript
class LogRocket {
    method() {
        console.log("This is a method call implementing an interface");
    }
}
```

现在我们已经知道了如何在 JavaScript 中创建和使用接口。接下来我们需要做的是说明如何在 JavaScript 中隔离接口，以便我们可以看到它是如何组合在一起并使代码更易于维护的。

在下面的示例中，我们将使用打印机来说明接口隔离原则。

假设我们有一台打印机、扫描仪和传真机，让我们创建一个定义这些对象功能的接口：

```javascript
const printerInterface = {
    print: function () { }
}

const scannerInterface = {
    scan: function () { }
}

const faxInterface = {
    fax: function () { }
}
```

在上面的代码中，我们创建了一系列分离的或隔离的接口，而不是一个定义所有这些功能的大型接口。通过将这些功能分解为更小的部分和更具体的接口，我们允许不同的客户端只实现他们需要的方法，并排除所有其他部分。

在下一步中，我们将创建实现这些接口的类。遵循接口隔离原则，每个类将只实现它需要的方法。

如果我们想要实现一个只能打印文档的基本打印机，我们可以通过printerInterface只实现print()方法，如下所示：

```javascript
class Printer {
    print() {
        console.log("printing document");
    }
}
```

这个类只实现了PrinterInterface。它不实现scan或fax方法。通过遵循接口隔离原则，客户端（在这种情况下是Printer类）降低了其复杂性并提高了软件的性能。

## 依赖倒置原则（DIP）

这个原则说，高层模块（业务逻辑）应该依赖于抽象，而不是直接依赖于低层模块（具体实现）。它帮助我们减少代码依赖，并为开发人员提供在更高层次上修改和扩展应用程序的灵活性，而不会遇到复杂情况。

为什么依赖倒置原则倾向于抽象而不是直接依赖呢？这是因为抽象的引入减少了变化的潜在影响，提高了可测试性（模拟抽象而不是具体实现），并在你的代码中实现了更高程度的灵活性。这个规则使得通过模块化方法更容易扩展软件组件，也帮助我们修改低层组件而不影响高层逻辑。

遵循依赖倒置原则使代码更易于维护、扩展，从而避免因代码变化而可能出现的错误。它建议开发人员在类之间使用松耦合而不是紧耦合。一般来说，通过采用优先考虑抽象而不是直接依赖的思维方式，团队将获得适应和添加新功能或更改旧组件的敏捷性，而不会引起连锁干扰。在 JavaScript 中，我们可以使用依赖注入方法来实现依赖倒置原则，如下所示：

```javascript
class MySQLDatabase {
    connect() {
        console.log('Connecting to MySQL database...');
    }
}

class MongoDBDatabase {
    connect() {
        console.log('Connecting to MongoDB database...');
    }
}

class Application {
    constructor(database) {
        this.database = database;
    }

    start() {
        this.database.connect();
    }
}

const mySQLDatabase = new MySQLDatabase();
const mySQLApp = new Application(mySQLDatabase);
mySQLApp.start();

const mongoDatabase = new MongoDBDatabase();
const mongoApp = new Application(mongoDatabase);
mongoApp.start();
```

在上面的基本示例中，Application类是高层模块，它依赖于数据库抽象。我们创建了两个数据库类：MySQLDatabase和MongoDBDatabase。数据库是低层模块，它们的实例被注入到Application运行时中，而无需修改Application本身。

## 结论

SOLID 原则是可扩展、可维护和健壮软件设计的基本构建块。这组原则帮助开发人员编写干净、模块化和适应性强的代码。

SOLID 原则促进了内聚功能、无需修改的可扩展性、对象替换、接口分离以及抽象优于依赖。
