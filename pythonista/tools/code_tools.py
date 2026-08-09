#!/usr/bin/env python3
"""
Code Tools — 4 Code Intelligence Tools for Nova
Nova by FreddyCreates — Pythonista iOS

Tools:
- GENC: Generate — Code generation
- REVC: Review — Code review
- REFC: Refactor — Code refactoring
- DOCC: Document — Code documentation
"""

import re
import math
import random
from typing import Dict, List, Optional
from collections import Counter
from .base import NovaTool, PHI, PHI_INV


# ─── GENERATE TOOL ───────────────────────────────────────────────────────────
class GenerateTool(NovaTool):
    """
    GENC — Code Generation Tool
    
    Generates code from natural language descriptions.
    """
    
    QUAD = 'GENC'
    NAME = 'Generate Code'
    DESCRIPTION = 'Code generation from natural language with φ-structured templates'
    CATEGORY = 'code'
    FIB_INDEX = 13
    MODALITIES = ['text', 'code', 'structured']
    ALPHA_ENGINES = ['ALPHA-001 ANIMUS', 'ALPHA-005 FABRICA']
    
    # Code templates
    TEMPLATES = {
        'function': '''def {name}({params}):
    """
    {description}
    
    Args:
        {args_doc}
    
    Returns:
        {returns_doc}
    """
    {body}
    return result
''',
        'class': '''class {name}:
    """
    {description}
    """
    
    def __init__(self{params}):
        {init_body}
    
    def {method_name}(self{method_params}):
        """
        {method_doc}
        """
        {method_body}
''',
        'loop': '''for {var} in {iterable}:
    {body}
''',
    }
    
    def _run(self, description: str, language: str = 'python',
             template: str = 'function', **kwargs) -> Dict:
        """
        Generate code from description.
        
        Args:
            description: Natural language description
            language: Target programming language
            template: Code template type
        
        Returns:
            Dict with generated code
        """
        # Extract key terms from description
        words = description.lower().split()
        
        # Generate function name from description
        name_words = [w for w in words if len(w) > 3 and w.isalpha()][:3]
        func_name = '_'.join(name_words) if name_words else 'nova_function'
        
        # Detect parameters from description
        param_patterns = ['with', 'using', 'takes', 'accepts']
        params = []
        for i, word in enumerate(words):
            if word in param_patterns and i + 1 < len(words):
                params.append(words[i + 1])
        
        params = params[:3] if params else ['data']
        param_str = ', '.join(params)
        
        # Generate code based on template
        if template == 'function':
            code = self.TEMPLATES['function'].format(
                name=func_name,
                params=param_str,
                description=description,
                args_doc='\n        '.join(f'{p}: Input parameter' for p in params),
                returns_doc='Processed result',
                body=f'    result = {params[0]} * PHI  # φ-weighted processing',
            )
        elif template == 'class':
            code = self.TEMPLATES['class'].format(
                name=func_name.title().replace('_', ''),
                description=description,
                params=', ' + param_str if params else '',
                init_body='\n        '.join(f'self.{p} = {p}' for p in params),
                method_name='process',
                method_params='',
                method_doc='Process the data.',
                method_body='return self.data * PHI',
            )
        else:
            code = self.TEMPLATES['loop'].format(
                var='item',
                iterable='data',
                body='    process(item)',
            )
        
        # Compute metrics
        lines = code.strip().split('\n')
        
        return {
            'code': code,
            'language': language,
            'template': template,
            'function_name': func_name,
            'parameters': params,
            'lines': len(lines),
            'characters': len(code),
            'confidence': round(0.7 + len(params) * 0.1, 4),
            'completeness': round(min(len(lines) / 20, 1.0), 4),
        }


# ─── REVIEW TOOL ─────────────────────────────────────────────────────────────
class ReviewTool(NovaTool):
    """
    REVC — Code Review Tool
    
    Reviews code for quality, style, and potential issues.
    """
    
    QUAD = 'REVC'
    NAME = 'Review Code'
    DESCRIPTION = 'Code review with φ-weighted quality scoring'
    CATEGORY = 'code'
    FIB_INDEX = 14
    MODALITIES = ['code', 'text']
    ALPHA_ENGINES = ['ALPHA-001 ANIMUS', 'ALPHA-007 VERITAS']
    
    # Code quality patterns
    ISSUES = {
        'long_line': (r'.{80,}', 'Line exceeds 80 characters', 'style'),
        'no_docstring': (r'def \w+\([^)]*\):\s*[^"\']', 'Missing docstring', 'documentation'),
        'magic_number': (r'[^0-9][0-9]{2,}[^0-9]', 'Magic number detected', 'maintainability'),
        'todo': (r'#\s*TODO', 'TODO comment found', 'completeness'),
        'fixme': (r'#\s*FIXME', 'FIXME comment found', 'quality'),
        'bare_except': (r'except:', 'Bare except clause', 'error_handling'),
        'print_debug': (r'print\(', 'Print statement (debug?)', 'debug'),
    }
    
    def _run(self, code: str, language: str = 'python', **kwargs) -> Dict:
        """
        Review code for issues.
        
        Args:
            code: Source code to review
            language: Programming language
        
        Returns:
            Dict with review results
        """
        lines = code.split('\n')
        issues = []
        
        # Check each pattern
        for issue_name, (pattern, message, category) in self.ISSUES.items():
            for i, line in enumerate(lines):
                if re.search(pattern, line):
                    issues.append({
                        'type': issue_name,
                        'message': message,
                        'category': category,
                        'line': i + 1,
                        'severity': 'warning' if category in ['style', 'debug'] else 'error',
                    })
        
        # Compute metrics
        total_lines = len(lines)
        code_lines = len([l for l in lines if l.strip() and not l.strip().startswith('#')])
        comment_lines = len([l for l in lines if l.strip().startswith('#')])
        blank_lines = len([l for l in lines if not l.strip()])
        
        # Quality score (φ-weighted)
        issue_penalty = len(issues) * 0.1
        quality_score = max(0, 1.0 - issue_penalty * PHI_INV)
        
        # Complexity estimate (cyclomatic-like)
        complexity_keywords = ['if', 'elif', 'else', 'for', 'while', 'try', 'except', 'with']
        complexity = 1 + sum(code.count(kw) for kw in complexity_keywords)
        
        return {
            'issues': issues,
            'issue_count': len(issues),
            'metrics': {
                'total_lines': total_lines,
                'code_lines': code_lines,
                'comment_lines': comment_lines,
                'blank_lines': blank_lines,
                'comment_ratio': round(comment_lines / code_lines, 4) if code_lines else 0,
                'complexity': complexity,
            },
            'quality_score': round(quality_score, 4),
            'language': language,
            'confidence': round(quality_score, 4),
            'completeness': round(1.0, 4),
        }


# ─── REFACTOR TOOL ───────────────────────────────────────────────────────────
class RefactorTool(NovaTool):
    """
    REFC — Code Refactoring Tool
    
    Suggests and applies code refactoring.
    """
    
    QUAD = 'REFC'
    NAME = 'Refactor Code'
    DESCRIPTION = 'Code refactoring with φ-optimal structure'
    CATEGORY = 'code'
    FIB_INDEX = 15
    MODALITIES = ['code', 'structured']
    ALPHA_ENGINES = ['ALPHA-005 FABRICA', 'ALPHA-001 ANIMUS']
    
    def _run(self, code: str, language: str = 'python', **kwargs) -> Dict:
        """
        Suggest refactoring for code.
        
        Args:
            code: Source code to refactor
            language: Programming language
        
        Returns:
            Dict with refactoring suggestions
        """
        suggestions = []
        refactored = code
        
        # Extract function names
        func_pattern = r'def (\w+)\('
        functions = re.findall(func_pattern, code)
        
        # Check for long functions
        func_bodies = re.split(r'\ndef ', code)
        for i, body in enumerate(func_bodies[1:], 1):
            lines = body.split('\n')
            if len(lines) > 20:
                suggestions.append({
                    'type': 'extract_function',
                    'message': f'Function is too long ({len(lines)} lines). Consider extracting.',
                    'severity': 'suggestion',
                    'phi_optimal_length': 13,  # F7
                })
        
        # Check for duplicate code patterns
        lines = code.split('\n')
        line_counts = Counter(l.strip() for l in lines if l.strip())
        duplicates = [(line, count) for line, count in line_counts.items() if count > 2]
        
        for line, count in duplicates[:3]:
            suggestions.append({
                'type': 'remove_duplication',
                'message': f'Line appears {count} times: "{line[:30]}..."',
                'severity': 'suggestion',
            })
        
        # Suggest naming improvements
        for func in functions:
            if len(func) < 3:
                suggestions.append({
                    'type': 'rename',
                    'message': f'Function name "{func}" is too short. Use descriptive names.',
                    'severity': 'suggestion',
                })
            elif '_' not in func and not func.islower():
                suggestions.append({
                    'type': 'naming_convention',
                    'message': f'Function "{func}" should use snake_case.',
                    'severity': 'style',
                })
        
        # Apply simple refactoring
        # Replace magic numbers with constants
        refactored = re.sub(r'(\s)(\d{3,})(\s)', r'\1CONSTANT_\2\3', refactored)
        
        # Compute improvement score
        improvement = len(suggestions) * PHI_INV * 0.1
        
        return {
            'original_lines': len(lines),
            'refactored_lines': len(refactored.split('\n')),
            'suggestions': suggestions,
            'suggestion_count': len(suggestions),
            'functions_found': functions,
            'improvement_potential': round(improvement, 4),
            'language': language,
            'confidence': round(0.8, 4),
            'completeness': round(min(len(suggestions) / 5, 1.0), 4),
        }


# ─── DOCUMENT TOOL ───────────────────────────────────────────────────────────
class DocumentTool(NovaTool):
    """
    DOCC — Code Documentation Tool
    
    Generates documentation from code.
    """
    
    QUAD = 'DOCC'
    NAME = 'Document Code'
    DESCRIPTION = 'Auto-generate documentation with φ-structured format'
    CATEGORY = 'code'
    FIB_INDEX = 16
    MODALITIES = ['code', 'text', 'documentation']
    ALPHA_ENGINES = ['ALPHA-002 LINGUA', 'ALPHA-001 ANIMUS']
    
    def _run(self, code: str, language: str = 'python',
             format: str = 'markdown', **kwargs) -> Dict:
        """
        Generate documentation from code.
        
        Args:
            code: Source code to document
            language: Programming language
            format: Output format (markdown, rst, html)
        
        Returns:
            Dict with generated documentation
        """
        # Extract functions
        func_pattern = r'def (\w+)\(([^)]*)\):'
        functions = re.findall(func_pattern, code)
        
        # Extract classes
        class_pattern = r'class (\w+)(?:\([^)]*\))?:'
        classes = re.findall(class_pattern, code)
        
        # Extract existing docstrings
        docstring_pattern = r'"""([^"]+)"""'
        docstrings = re.findall(docstring_pattern, code)
        
        # Generate documentation
        doc_parts = []
        
        # Header
        doc_parts.append(f"# Code Documentation\n")
        doc_parts.append(f"*Generated by Nova DOCC tool*\n")
        doc_parts.append(f"*φ = {PHI}*\n\n")
        
        # Classes section
        if classes:
            doc_parts.append("## Classes\n\n")
            for cls in classes:
                doc_parts.append(f"### `{cls}`\n\n")
                doc_parts.append(f"Class `{cls}` provides...\n\n")
        
        # Functions section
        if functions:
            doc_parts.append("## Functions\n\n")
            for func_name, params in functions:
                doc_parts.append(f"### `{func_name}({params})`\n\n")
                
                # Parse parameters
                if params:
                    param_list = [p.strip() for p in params.split(',')]
                    doc_parts.append("**Parameters:**\n\n")
                    for param in param_list:
                        param_name = param.split(':')[0].split('=')[0].strip()
                        doc_parts.append(f"- `{param_name}`: Description\n")
                    doc_parts.append("\n")
                
                doc_parts.append("**Returns:** Result\n\n")
        
        # Metrics
        doc_parts.append("## Metrics\n\n")
        line_count = len(code.splitlines())
        doc_parts.append(f"- Lines of code: {line_count}\n")
        doc_parts.append(f"- Functions: {len(functions)}\n")
        doc_parts.append(f"- Classes: {len(classes)}\n")
        doc_parts.append(f"- Existing docstrings: {len(docstrings)}\n")
        
        documentation = ''.join(doc_parts)
        
        return {
            'documentation': documentation,
            'format': format,
            'language': language,
            'extracted': {
                'functions': [f[0] for f in functions],
                'classes': classes,
                'docstrings': len(docstrings),
            },
            'doc_lines': len(documentation.split('\n')),
            'confidence': round(0.85, 4),
            'completeness': round(min((len(functions) + len(classes)) / 10, 1.0), 4),
        }


# ─── Quick Access Functions ──────────────────────────────────────────────────
_generate_tool = None
_review_tool = None
_refactor_tool = None
_document_tool = None

def generate_code(description: str, **kwargs) -> Dict:
    """Quick access to code generation."""
    global _generate_tool
    if _generate_tool is None:
        _generate_tool = GenerateTool()
    return _generate_tool.execute(description, **kwargs)

def review_code(code: str, **kwargs) -> Dict:
    """Quick access to code review."""
    global _review_tool
    if _review_tool is None:
        _review_tool = ReviewTool()
    return _review_tool.execute(code, **kwargs)

def refactor_code(code: str, **kwargs) -> Dict:
    """Quick access to code refactoring."""
    global _refactor_tool
    if _refactor_tool is None:
        _refactor_tool = RefactorTool()
    return _refactor_tool.execute(code, **kwargs)

def document_code(code: str, **kwargs) -> Dict:
    """Quick access to code documentation."""
    global _document_tool
    if _document_tool is None:
        _document_tool = DocumentTool()
    return _document_tool.execute(code, **kwargs)


# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║              Code Tools — Self-Test                            ║")
    print("║              Nova by FreddyCreates                             ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    print("─── GENERATE ───")
    result = generate_code("calculate fibonacci with number n")
    print(f"Generated {result['lines']} lines")
    print(f"Function: {result['function_name']}")
    print()
    
    test_code = '''
def calc(x):
    # TODO: fix this
    result = x * 1000
    print(result)
    return result

def calc(x):
    result = x * 1000
    return result
'''
    
    print("─── REVIEW ───")
    result = review_code(test_code)
    print(f"Issues: {result['issue_count']}")
    print(f"Quality: {result['quality_score']}")
    print()
    
    print("─── REFACTOR ───")
    result = refactor_code(test_code)
    print(f"Suggestions: {result['suggestion_count']}")
    print(f"Improvement: {result['improvement_potential']}")
    print()
    
    print("─── DOCUMENT ───")
    result = document_code(test_code)
    print(f"Doc lines: {result['doc_lines']}")
    print(f"Functions: {result['extracted']['functions']}")
    print()
    
    print("✓ Code tools ready.")
