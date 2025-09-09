from typing import List, Dict

def summarize(nums: List[int]) -> Dict[str, float]:
    if not nums:
        raise ValueError("La lista está vacía")
    if not all(isinstance(x, (int, float)) for x in nums):
        raise ValueError("Todos los elementos deben ser números")
    
    total = sum(nums)
    count = len(nums)
    avg = total / count
    return {"count": count, "sum": total, "avg": avg}

# CLI
if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Uso: python -m app '1,2,3'")
        sys.exit(1)
    
    try:
        nums = [float(x) for x in sys.argv[1].split(",")]
        result = summarize(nums)
        print(result)
    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)
