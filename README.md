# Automatic Differentiation Library with Web Interface in OCaml

## Note
The project now includes a comprehensive web interface for visualizing and better understanding of automatic differentiation. Each example includes both computational output and visual representation of the operations being performed. The examples range from basic operations to neural networks, demonstrating the applications of Automatic Differentiation.

## Recent Updates

### 1. Added Web Interface
- Implemented a web-based interface using Dream for visualizing and running examples
- Added interactive visualization of computational graphs for each example
- Included real-time output display
- Added loading indicators for long-running examples

### 2. Neural Network Improvements
- Fixed and enhanced the neural network implementation
- Added proper initialization and gradient handling
- Improved training metrics and visualization
- Achieved 99% accuracy on binary classification task
- Added detailed training progress visualization

### 3. Computational Graphs
Added visualizations for different examples:
- Basic operations graph
- Simple derivative computations
- Large matrix operations
- Neural network architecture and training
- Computation graph visualization

### 4. Front-end Features
- Real-time graph generation using Graphviz
- Detailed output formatting

### 5. Code Organization
- Separated frontend and backend code
- Added proper error handling
- Improved code documentation
- Removed unused dependencies (oplot)

## Running the Project

1. Build the project:
```bash
dune build
```

2. Start the web server:
```bash
dune exec frontend/server.exe
```

3. Access the web interface:
```
http://localhost:8080
```

## Example Descriptions

1. **Basic Operations** (`basic.ml`)
   - Demonstrates fundamental tensor operations (creation, addition, multiplication)
   - Shows element-wise operations on tensors
   - Includes examples of matrix multiplication and dot products
   - Visualizes how basic operations are composed in the computational graph
   - Useful for understanding the building blocks of the autodiff system

2. **Simple Derivatives** (`simple.ml`)
   - Compares automatic differentiation results with numerical estimates
   - Implements functions like `f(a,b) = (a * (a/b)) + (a + b)`
   - Shows computation of partial derivatives
   - Demonstrates the accuracy of autodiff vs numerical approaches
   - Provides clear examples of chain rule application

3. **Large Matrix Operations** (`large.ml`)
   - Tests the system with large matrices (1000x1000)
   - Demonstrates performance on complex matrix operations
   - Includes timing information for computations
   - Shows how the system handles memory-intensive operations
   - Takes approximately 40 seconds to execute due to size

4. **Neural Network** (`nn.ml`)
   - Implements a binary classification neural network
   - Shows the training process over 100 epochs
   - Uses leaky ReLU and sigmoid activations
   - Demonstrates gradient descent optimization
   - Achieves 99% accuracy with visualized training progress

5. **Computation Graph Visualization** (`printed.ml`)
   - Shows the internal representation of the computation graph
   - Displays how operations are broken down into elementary compositions
   - Visualizes gradient flow through the network
   - Helps understand the underlying autodiff mechanism
   - Useful for debugging and understanding backpropagation


## Dependencies
- core
- dream (web server)
- graphviz (for graph generation)
- bigarray
